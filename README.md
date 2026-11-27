# claude-config

My global Claude Code setup (instructions + skills) for cloud environments.

## Use in a Claude Code cloud environment

Paste this into the environment's **setup script**:

```bash
git clone --depth 1 https://github.com/Naadeer005/claude-config.git /tmp/claude-config && bash /tmp/claude-config/setup.sh
```

Every session in that environment then gets `~/.claude/CLAUDE.md` and the skills, whatever work repo it opens.

## Change it

- Instructions / memory: edit `CLAUDE.md`.
- Your own skill: add `skills/<name>/SKILL.md`.
- Someone else's skill: add a `fetch <owner/repo> <path>` line in `setup.sh`.
- Plugin: add its marketplace and `name@marketplace` to the two lists in `setup.sh`.

Commit and push; the next cloud session picks it up. This repo is public, so never put secrets here.
