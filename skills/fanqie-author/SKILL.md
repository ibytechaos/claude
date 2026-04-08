---
name: fanqie-author
description: "Use when managing novels on Fanqie (番茄小说). Create books, publish chapters, batch publish, check stats. Examples: '发布章节到番茄', '创建新书', '批量发布小说', 'fanqie publish', '查看番茄数据'"
version: 1.0.0
author: wuzhipeng
tags: [fanqie, novel, publish, content-creation, chinese-platform]
---

# 番茄小说作者后台

## 快速开始

**零依赖，免安装。** 本 Skill 自带 `scripts/fanqie.mjs`，Node.js 20+ 直接运行。

### 前置条件

1. Chrome 以 `--remote-debugging-port=9222` 启动
2. 浏览器已登录 `fanqienovel.com`

### 命令

```bash
FANQIE="<skill_dir>/scripts/fanqie.mjs"

# 查询
node $FANQIE books                                        # 作品列表
node $FANQIE chapters <book_id>                           # 章节列表
node $FANQIE volumes <book_id>                            # 分卷列表
node $FANQIE drafts <book_id>                             # 草稿列表
node $FANQIE stats                                        # 作者信息

# 创作
node $FANQIE create-book --name "书名" --abstract "简介"    # 创建新书
node $FANQIE publish <book_id> --title "第1章 标题" --file ch.txt   # 发布单章
node $FANQIE batch-publish <book_id> --dir ./chapters/     # 批量发布
node $FANQIE update <item_id> --book-id <id> --file new.txt  # 更新章节
node $FANQIE delete <item_id> --book-id <id>               # 删除章节

# 环境变量
FANQIE_CDP_PORT=9222   # Chrome CDP 端口（默认 9222）
```

### 批量发布文件规范

```
chapters/
├── 001-第1章 ��醒.txt      # 文件名 = 序号-章节标题.txt
├── 002-���2章 修炼.txt      # 标题直接用作发布标题
├── 003-第3章 突破.txt      # 纯文本，段落用空行分隔
```

每章 ≥ 1000 字，标题 ≥ 5 字，章节号用阿拉伯数字。

---

## 技术方案

**浏览器内 API 直调**：通过 CDP 连接 Chrome，在浏览器上下文内执行 `fetch()`。浏览器自动处理 cookie/msToken 鉴权。不碰 DOM，不模拟点击。

发布链路：`new_article` → `cover_article` → `publish_article`

已验证：20章批量发布 100% 成功率，3秒/章。

---

## 平台规则

| 规则 | 详情 |
|------|------|
| 标题 | ≥ 5 字，章节号只支持阿拉伯数字（第1章，非第一章） |
| 正文 | ≥ 1000 字，HTML 格式（`<p>` 标签包裹段落） |
| AI 声明 | publish_article 参数 `use_ai=2` 表示"否" |
| 书名 | ≤ 15 字 |
| 简介 | 50-500 字 |
| 发布间隔 | 建议 ≥ 3 秒（实测无限流） |

---

## 已验证 API

所有 API 需要 `aid=2503&app_name=muye_novel`，POST 用 `application/x-www-form-urlencoded`。

| API | 方法 | 用途 |
|-----|------|------|
| `/api/author/book/book_list/v0` | GET | 作品列表 |
| `/api/author/book/create/v0/` | POST | 创建新书 |
| `/api/author/book/book_detail/v0/` | GET | 作品详情 |
| `/api/author/chapter/chapter_list/v1` | GET | 章节列表 |
| `/api/author/volume/volume_list/v1` | GET | 分卷列表 |
| `/api/author/article/new_article/v0/` | POST | 创建草稿（返回 item_id） |
| `/api/author/article/cover_article/v0/` | POST | 保存标题+内容 |
| `/api/author/publish_article/v0/` | POST | 确认发布 |
| `/api/author/account/info/v0/` | GET | 作者账���信息 |
| `/api/author/book/category_list/v0/` | GET | 作品分类列表 |

### publish_article 完整参数

```
item_id, book_id, volume_id, volume_name, title, content,
publish_status=1, use_ai=2, device_platform=pc,
timer_status=0, need_pay=0, speak_type=0,
timer_time=, timer_chapter_preview=[], has_chapter_ad=false, chapter_ad_types=
```

缺任何一个都会报"缺少书籍卷相关参数"。

---

## 错题本

| # | 坑 | 正确做法 |
|---|-----|---------|
| 1 | 后台 URL 猜 `writer.fanqie.com` | 实际在 `fanqienovel.com/main/writer/` |
| 2 | POST 用 JSON | 字节系全用 form-urlencoded |
| 3 | `cover_article` 当发布用 | 它只保存草稿，需额外调 `publish_article` |
| 4 | 纯 API 保存后前端验证不过 | 前端验证基于 DOM 状态，纯 API 方案不受影响 |
| 5 | `innerHTML` 填 ProseMirror | 需用 CDP `Input.insertText` |
| 6 | `nativeInputValueSetter` 填 React input | 需用 CDP `Input.insertText` |
| 7 | "非AI"是 checkbox | 实际是 radio 按钮，`use_ai=2` 表示"否" |
| 8 | 点"下一步"无反应 | 风险检测弹窗拦截，需点取消 |
| 9 | 用 `chapter_id` 字段名 | 番茄全用 `item_id` |
| 10 | publish 只传 item_id+book_id+content | 必须带 volume_id、volume_name 等完整参数 |
| 11 | `need_reuse=1` 创建新草稿 | `=1` 复用旧草稿，`=0` 才是新建 |

---

## 后台地址

- 作品管理: `https://fanqienovel.com/main/writer/book-manage`
- 章节管理: `https://fanqienovel.com/main/writer/chapter-manage/<book_id>`
- 创建章节: `https://fanqienovel.com/main/writer/<book_id>/publish/`
- 创建新��: `https://fanqienovel.com/main/writer/create`
