---
name: context7-cli
description: Use the ctx7 CLI to fetch library documentation, manage AI coding skills, and configure Context7 MCP. Activate when the user mentions "ctx7" or "context7", needs current docs for any library, wants to install/search/generate skills, or needs to set up Context7 for their AI coding agent.
---

# ctx7 CLI

The Context7 CLI fetches up-to-date library documentation, manages AI coding skills, and sets up Context7 MCP for your editor.

```bash
npm install -g ctx7@latest
# Or run directly:
npx ctx7@latest <command>
```

## Quick Reference

```bash
# Documentation
ctx7 library <name> <query>           # Step 1: resolve library ID
ctx7 docs <libraryId> <query>         # Step 2: fetch docs

# Skills
ctx7 skills install /owner/repo       # Install from a repo (interactive)
ctx7 skills install /owner/repo name  # Install a specific skill
ctx7 skills search <keywords>         # Search the registry
ctx7 skills suggest                   # Auto-suggest based on project deps
ctx7 skills list                      # List installed skills
ctx7 skills remove <name>             # Uninstall a skill
ctx7 skills generate                  # Generate a custom skill with AI (requires login)

# Setup
ctx7 setup                            # Configure Context7 MCP (interactive)
ctx7 login                            # Log in for higher rate limits + skill generation
ctx7 whoami                           # Check current login status
```

## Authentication

```bash
ctx7 login               # Opens browser for OAuth
ctx7 login --no-browser  # Prints URL instead of opening browser
ctx7 logout              # Clear stored tokens
ctx7 whoami              # Show current login status
```

Most commands work without login. Set an API key via environment variable to skip interactive login:

```bash
export CONTEXT7_API_KEY=your_key
```

## Common Mistakes

- Library IDs require a `/` prefix — `/facebook/react` not `facebook/react`
- Always run `ctx7 library` first
- Repository format for skills is `/owner/repo`
- `skills generate` requires login — run `ctx7 login` first
