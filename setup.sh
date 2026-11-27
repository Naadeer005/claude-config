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

# Plugins (each bundles more skills). A failure here only skips that plugin.
if command -v claude >/dev/null; then
  for m in anthropics/claude-plugins-official \
           https://github.com/blader/humanizer.git \
           https://github.com/pbakaus/impeccable.git \
           https://github.com/DietrichGebert/ponytail.git; do
    claude plugin marketplace add "$m" >/dev/null 2>&1 || echo "warn: marketplace $m not added"
  done
  for p in superpowers@claude-plugins-official frontend-design@claude-plugins-official \
           humanizer@humanizer impeccable@impeccable ponytail@ponytail; do
    claude plugin install "$p" >/dev/null 2>&1 && echo "plugin ok: $p" || echo "warn: plugin $p not installed"
  done
else
  echo "warn: claude CLI not found, plugins skipped"
fi
