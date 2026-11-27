#!/usr/bin/env bash
# Installs this repo's global Claude Code config into ~/.claude (for cloud environments).
# Cloud environment setup script:
#   git clone --depth 1 https://github.com/Naadeer005/claude-config.git /tmp/claude-config && bash /tmp/claude-config/setup.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
mkdir -p ~/.claude/skills

cp "$HERE/CLAUDE.md" ~/.claude/CLAUDE.md
cp -r "$HERE/skills/." ~/.claude/skills/   # your own skills: skills/<name>/SKILL.md
rm -f ~/.claude/skills/.gitkeep

# Third-party skills, fetched from upstream instead of copied into this repo.
fetch() { # <owner/repo> <path to skill folder in that repo>
  local dir="$TMP/${1//\//_}"
  [ -d "$dir" ] || git clone --depth 1 -q "https://github.com/$1.git" "$dir"
  cp -r "$dir/$2" ~/.claude/skills/
}
fetch vercel-labs/skills       skills/find-skills
fetch greensock/gsap-skills    skills/gsap-react
fetch greensock/gsap-skills    skills/gsap-scrolltrigger
fetch cloudai-x/threejs-skills skills/threejs-react-three-fiber
fetch pbakaus/impeccable       .agents/skills/impeccable

rm -rf "$TMP"
echo "Installed skills: $(ls ~/.claude/skills | tr '\n' ' ')"
