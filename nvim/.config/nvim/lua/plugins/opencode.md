# OpenCode Setup Notes

Quick reference for setting up OpenCode providers on a new machine.

## 1) Codex auth bridge (ChatGPT OAuth)

Source: https://github.com/numman-ali/opencode-openai-codex-auth

Install with npx:

```bash
npx -y opencode-openai-codex-auth@latest
```

Login:

```bash
opencode auth login
```

Quick verify:

```bash
opencode run "write hello world to test.txt" --model=openai/gpt-5.2 --variant=medium
```

Legacy OpenCode (v1.0.209 and below):

```bash
npx -y opencode-openai-codex-auth@latest --legacy
```

Uninstall:

```bash
npx -y opencode-openai-codex-auth@latest --uninstall
# remove everything
npx -y opencode-openai-codex-auth@latest --uninstall --all
```

## 2) Cursor ACP provider (Cursor models in OpenCode)

Source: https://github.com/Nomadcxx/opencode-cursor

Install with npm:

```bash
npm install -g @rama_nigg/open-cursor
open-cursor install
```

Login via OpenCode:

```bash
opencode auth login
```

When prompted:
- choose provider: `Other`
- provider id: `cursor-acp`

Run with Cursor provider:

```bash
opencode run "your prompt" --model cursor-acp/auto
```

Alternative direct auth (if needed):

```bash
cursor-agent login
```
