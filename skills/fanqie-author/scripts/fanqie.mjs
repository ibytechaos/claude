#!/usr/bin/env node
/**
 * fanqie.mjs — 番茄小说作者后台 CLI（零依赖，免安装）
 *
 * 通过 CDP 连接 Chrome，在浏览器内调用番茄 API。
 * 前置条件：Chrome 以 --remote-debugging-port=9222 启动，并已登录 fanqienovel.com
 *
 * Usage:
 *   node fanqie.mjs books
 *   node fanqie.mjs chapters <book_id>
 *   node fanqie.mjs publish <book_id> --title "第1章 标题" --file chapter.txt
 *   node fanqie.mjs batch-publish <book_id> --dir ./chapters/
 *   node fanqie.mjs create-book --name "书名" --abstract "简介"
 */

import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, basename, join } from 'node:path';

// Node 22+ has built-in WebSocket; older versions need 'ws' package
const WS = globalThis.WebSocket ?? (await import('ws')).default;

// ── CDP Connection ──────────────────────────────────────────────────────────

const CDP_PORT = process.env.FANQIE_CDP_PORT || '9222';

let ws, msgId = 1;

async function cdpConnect() {
  const resp = await fetch(`http://127.0.0.1:${CDP_PORT}/json`);
  const tabs = await resp.json();
  const tab = tabs.find(t => t.type === 'page' && /fanqie/i.test(t.url))
    || tabs.find(t => t.type === 'page');
  if (!tab?.webSocketDebuggerUrl) throw new Error('No Chrome tab found. Is Chrome running with --remote-debugging-port=' + CDP_PORT + '?');

  return new Promise((ok, fail) => {
    const w = new WS(tab.webSocketDebuggerUrl);
    w.on?.('error', fail) || w.addEventListener?.('error', fail);
    const onOpen = () => { ws = w; ok(w); };
    w.on?.('open', onOpen) || w.addEventListener?.('open', onOpen);
  });
}

function cdpSend(method, params = {}) {
  return new Promise((resolve) => {
    const id = msgId++;
    const timer = setTimeout(() => resolve(null), 15000);
    const handler = (raw) => {
      const data = typeof raw === 'string' ? raw : raw.data ?? raw.toString();
      const msg = JSON.parse(data);
      if (msg.id === id) {
        clearTimeout(timer);
        ws.off?.('message', handler) || ws.removeEventListener?.('message', handler);
        resolve(msg.result);
      }
    };
    ws.on?.('message', handler) || ws.addEventListener?.('message', handler);
    ws.send(JSON.stringify({ id, method, params }));
  });
}

// ── Fanqie API Layer ────────────────────────────────────────────────────────

async function fanqieApi(method, pathWithParams, body = null) {
  // Support both "/api/foo" and "/api/foo&key=val" (& used as separator for extra params)
  const [basePath, ...extraParts] = pathWithParams.split('&');
  const extra = extraParts.length ? '&' + extraParts.join('&') : '';
  const sep = basePath.includes('?') ? '&' : '?';
  const url = `https://fanqienovel.com${basePath}${sep}aid=2503&app_name=muye_novel${extra}`;

  let bodyJs = '';
  if (body) {
    const encoded = Object.entries(body)
      .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(String(v))}`)
      .join('&');
    bodyJs = `body: ${JSON.stringify(encoded)},`;
  }

  const js = `(async()=>{
    const r = await fetch(${JSON.stringify(url)}, {
      method: ${JSON.stringify(method)},
      credentials: 'include',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ${bodyJs}
    });
    return JSON.stringify(await r.json());
  })()`;

  const res = await cdpSend('Runtime.evaluate', {
    expression: js, returnByValue: true, awaitPromise: true,
  });
  if (!res?.result?.value) throw new Error('API call failed (no response)');
  const data = JSON.parse(res.result.value);
  if (data.code !== 0) throw new Error(`API error ${data.code}: ${data.message}`);
  return data;
}

// ── Text Helpers ────────────────────────────────────────────────────────────

function textToHtml(text) {
  return text.split(/\n+/).filter(l => l.trim()).map(l => `<p>${l.trim()}</p>`).join('');
}

function charCount(text) {
  return text.replace(/\s/g, '').length;
}

// ── Args Parser ─────────────────────────────────────────────────────────────

function parseArgs(argv) {
  const args = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    if (argv[i].startsWith('--')) {
      const key = argv[i].slice(2);
      const next = argv[i + 1];
      if (next && !next.startsWith('--')) { args[key] = next; i++; }
      else { args[key] = true; }
    } else {
      args._.push(argv[i]);
    }
  }
  return args;
}

// ── Commands ────────────────────────────────────────────────────────────────

const commands = {

  async books() {
    const res = await fanqieApi('GET', '/api/author/book/book_list/v0&page_count=20&page_index=0', null);
    const books = res.data?.book_list ?? [];
    console.log(`共 ${books.length} 本作品:\n`);
    for (const b of books) {
      const tag = b.book_intro?.tag || (b.has_hide ? '已隐藏' : '-');
      console.log(`  ${b.book_id}  ${b.book_name}  ${b.content_word_number}字  ${b.chapter_number}章  [${tag}]`);
    }
  },

  async chapters(args) {
    const bookId = args._[0];
    if (!bookId) return console.error('Usage: fanqie chapters <book_id>');
    const limit = args.limit || 30;
    const res = await fanqieApi('GET', `/api/author/chapter/chapter_list/v1&book_id=${bookId}&page_index=0&page_count=${limit}&status=`);
    const items = res.data?.item_list ?? [];
    console.log(`共 ${res.data?.total_count ?? items.length} 章:\n`);
    for (const c of items) {
      const st = c.article_status === 1 ? '已发布' : '审核中';
      console.log(`  #${c.index}  ${c.item_id}  ${c.title}  ${c.word_number}字  [${st}]`);
    }
  },

  async volumes(args) {
    const bookId = args._[0];
    if (!bookId) return console.error('Usage: fanqie volumes <book_id>');
    const res = await fanqieApi('GET', `/api/author/volume/volume_list/v1&book_id=${bookId}`);
    for (const v of res.data?.volume_list ?? []) {
      console.log(`  ${v.volume_id}  ${v.volume_name}  ${v.item_count}章`);
    }
  },

  async stats() {
    const res = await fanqieApi('GET', '/api/author/account/info/v0/');
    const d = res.data;
    console.log(`作者: ${d.author_name} (${d.mp_name})`);
    console.log(`积分: ${d.point}`);
    for (const p of d.point_detail ?? []) {
      console.log(`  ${p.name}: ${p.point}`);
    }
  },

  async 'create-book'(args) {
    const name = args.name;
    const abstract = args.abstract;
    if (!name || !abstract) return console.error('Usage: fanqie create-book --name "书名" --abstract "50-500字简介"');
    if (name.length > 15) return console.error(`书名不能超过15字 (当前${name.length}字)`);
    if (abstract.length < 50) return console.error(`简介至少50字 (当前${abstract.length}字)`);

    const roles = args.protagonist ? args.protagonist.split(',').map(s => s.trim()) : [];
    const res = await fanqieApi('POST', '/api/author/book/create/v0/', {
      book_name: name, abstract, gender: args.gender || 1,
      roles: JSON.stringify(roles), category: args.category || '', thumb_uri: '',
    });
    console.log(`✅ 创建成功  book_id: ${res.data?.book_id}  书名: ${name}`);
  },

  async publish(args) {
    const bookId = args._[0];
    const title = args.title;
    const file = args.file;
    const content = args.content;
    const draft = args.draft;

    if (!bookId || !title) return console.error('Usage: fanqie publish <book_id> --title "第1章 标题" --file chapter.txt');
    if (title.length < 5) return console.error('标题至少5个字');
    if (/第[一二三四五六七八九十百千万]+章/.test(title)) return console.error('章节序号必须用阿拉伯数字');

    let raw = content;
    if (file) {
      const p = resolve(file);
      if (!existsSync(p)) return console.error(`文件不存在: ${p}`);
      raw = readFileSync(p, 'utf-8');
    }
    if (!raw) return console.error('需要 --file 或 --content');
    if (charCount(raw) < 1000) return console.error(`正文至少1000字，当前 ${charCount(raw)} 字`);

    const html = textToHtml(raw);

    // Create draft
    const create = await fanqieApi('POST', '/api/author/article/new_article/v0/', {
      book_id: bookId, need_reuse: 0,
    });
    const itemId = create.data?.item_id;

    // Save content
    await fanqieApi('POST', '/api/author/article/cover_article/v0/', {
      book_id: bookId, item_id: itemId, title, content: html,
    });

    if (!draft) {
      // Get volume
      const volRes = await fanqieApi('GET', `/api/author/volume/volume_list/v1&book_id=${bookId}`);
      const vol = volRes.data?.volume_list?.[0];
      if (!vol) return console.error('未找到分卷信息');

      await fanqieApi('POST', '/api/author/publish_article/v0/', {
        item_id: itemId, book_id: bookId,
        volume_id: vol.volume_id, volume_name: vol.volume_name,
        title, content: html,
        publish_status: 1, use_ai: 2, device_platform: 'pc',
        timer_status: 0, need_pay: 0, speak_type: 0,
        timer_time: '', timer_chapter_preview: '[]',
        has_chapter_ad: false, chapter_ad_types: '',
      });
    }

    console.log(`${draft ? '✅ 草稿' : '✅ 已发布'}  item_id: ${itemId}  ${title}  (${charCount(raw)}字)`);
  },

  async 'batch-publish'(args) {
    const bookId = args._[0];
    const dir = args.dir;
    const draft = args.draft;
    const delay = parseInt(args.delay || '3') * 1000;

    if (!bookId || !dir) return console.error('Usage: fanqie batch-publish <book_id> --dir ./chapters/');
    if (!existsSync(resolve(dir))) return console.error(`目录不存在: ${dir}`);

    const files = readdirSync(resolve(dir)).filter(f => /\.(txt|md)$/i.test(f)).sort();
    if (!files.length) return console.error('目录中没有 .txt/.md 文件');

    // Get volume
    let vol = null;
    if (!draft) {
      const volRes = await fanqieApi('GET', `/api/author/volume/volume_list/v1&book_id=${bookId}`);
      vol = volRes.data?.volume_list?.[0];
      if (!vol) return console.error('未找到分卷信息');
    }

    // Validate all first
    const chapters = files.map((f, i) => {
      const raw = readFileSync(join(resolve(dir), f), 'utf-8');
      const title = basename(f).replace(/\.(txt|md)$/i, '').replace(/^\d+[-_.\s]*/, '');
      const cc = charCount(raw);
      if (title.length < 5) { console.error(`❌ 标题过短: "${title}" (${f})`); process.exit(1); }
      if (cc < 1000) { console.error(`❌ 字数不足: ${cc}字 (${f})`); process.exit(1); }
      return { file: f, title, raw, html: textToHtml(raw), chars: cc, index: i + 1 };
    });

    console.log(`准备发布 ${chapters.length} 章到 book_id=${bookId}\n`);
    let ok = 0, fail = 0;

    for (const ch of chapters) {
      try {
        const create = await fanqieApi('POST', '/api/author/article/new_article/v0/', {
          book_id: bookId, need_reuse: 0,
        });
        const itemId = create.data?.item_id;

        await fanqieApi('POST', '/api/author/article/cover_article/v0/', {
          book_id: bookId, item_id: itemId, title: ch.title, content: ch.html,
        });

        if (!draft && vol) {
          await fanqieApi('POST', '/api/author/publish_article/v0/', {
            item_id: itemId, book_id: bookId,
            volume_id: vol.volume_id, volume_name: vol.volume_name,
            title: ch.title, content: ch.html,
            publish_status: 1, use_ai: 2, device_platform: 'pc',
            timer_status: 0, need_pay: 0, speak_type: 0,
            timer_time: '', timer_chapter_preview: '[]',
            has_chapter_ad: false, chapter_ad_types: '',
          });
        }

        console.log(`  ${ch.index}/${chapters.length} ✅ ${ch.title} (${ch.chars}字)`);
        ok++;
      } catch (e) {
        console.log(`  ${ch.index}/${chapters.length} ❌ ${ch.title} — ${e.message}`);
        fail++;
      }

      if (ch.index < chapters.length) await new Promise(r => setTimeout(r, delay));
    }

    console.log(`\n成功: ${ok}  失败: ${fail}  总计: ${chapters.length}`);
  },

  async drafts(args) {
    const bookId = args._[0];
    if (!bookId) return console.error('Usage: fanqie drafts <book_id>');
    const res = await fanqieApi('GET', `/api/author/chapter/chapter_list/v1&book_id=${bookId}&page_index=0&page_count=20&status=0`);
    const items = res.data?.item_list ?? [];
    console.log(`草稿 ${items.length} 章:\n`);
    for (const c of items) {
      console.log(`  #${c.index}  ${c.item_id}  ${c.title}  ${c.word_number}字`);
    }
  },

  async update(args) {
    const itemId = args._[0];
    const bookId = args['book-id'] || args.book_id;
    if (!itemId || !bookId) return console.error('Usage: fanqie update <item_id> --book-id <book_id> [--title "新标题"] [--file new.txt]');

    const body = { book_id: bookId, item_id: itemId };
    if (args.title) body.title = args.title;
    if (args.file) {
      const raw = readFileSync(resolve(args.file), 'utf-8');
      body.content = textToHtml(raw);
    }
    await fanqieApi('POST', '/api/author/article/cover_article/v0/', body);
    console.log(`✅ 已更新 ${itemId}`);
  },

  async delete(args) {
    const itemId = args._[0];
    const bookId = args['book-id'] || args.book_id;
    if (!itemId || !bookId) return console.error('Usage: fanqie delete <item_id> --book-id <book_id>');
    await fanqieApi('POST', '/api/author/article/delete_article/v0/', {
      book_id: bookId, item_id: itemId,
    });
    console.log(`✅ 已删除 ${itemId}`);
  },
};

// ── Main ────────────────────────────────────────────────────────────────────

const argv = process.argv.slice(2);
const cmd = argv[0];
const args = parseArgs(argv.slice(1));

if (!cmd || cmd === 'help' || cmd === '--help') {
  console.log(`
番茄小说作者后台 CLI (零依赖)

前置条件:
  Chrome 以 --remote-debugging-port=9222 启动
  浏览器已登录 fanqienovel.com

命令:
  books                              查看作品列表
  chapters <book_id>                 查看章节列表
  volumes <book_id>                  查看分卷
  drafts <book_id>                   查看草稿
  stats                              作者信息

  create-book --name "书名" --abstract "简介" [--protagonist "主角名"]
  publish <book_id> --title "第1章 标题" --file chapter.txt [--draft]
  batch-publish <book_id> --dir ./chapters/ [--draft] [--delay 3]
  update <item_id> --book-id <id> [--title "新标题"] [--file new.txt]
  delete <item_id> --book-id <id>

环境变量:
  FANQIE_CDP_PORT  Chrome CDP 端口 (默认: 9222)
`);
  process.exit(0);
}

if (!commands[cmd]) {
  console.error(`未知命令: ${cmd}\n运行 node fanqie.mjs help 查看帮助`);
  process.exit(1);
}

try {
  await cdpConnect();
  await commands[cmd](args);
} catch (e) {
  console.error(`❌ ${e.message}`);
  process.exit(1);
} finally {
  ws?.close?.();
}
