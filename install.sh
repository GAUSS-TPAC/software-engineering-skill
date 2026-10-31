#!/usr/bin/env bash
# Installs the "software-engineering" skill for several coding agents.
#
# Usage:
#   ./install.sh                     install for every agent (global, under $HOME)
#   ./install.sh claude opencode     install only for the listed agents
#   ./install.sh --link ...          create symlinks instead of copies
#   ./install.sh --project DIR       install into a project (.claude/skills, .opencode/skills,
#                                    .agents/skills, .gemini/skills) and add a section to DIR/AGENTS.md
#   ./install.sh --uninstall [...]   remove the skill
#
# Agents: claude, opencode, codex, gemini, agents (standard ~/.agents/skills folder)
set -euo pipefail

NAME="software-engineering"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$NAME"
MODE="copy"
ACTION="install"
PROJECT=""
AGENTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --link) MODE="link" ;;
    --uninstall) ACTION="uninstall" ;;
    --project) PROJECT="${2:?--project expects a directory}"; shift ;;
    -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
    claude|opencode|codex|gemini|agents) AGENTS+=("$1") ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
  shift
done

[[ -f "$SRC/SKILL.md" ]] || { echo "SKILL.md not found in $SRC" >&2; exit 1; }
[[ ${#AGENTS[@]} -eq 0 ]] && AGENTS=(claude opencode codex gemini agents)

global_dir() {
  case "$1" in
    claude)   echo "$HOME/.claude/skills" ;;
    opencode) echo "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills" ;;
    codex)    echo "${CODEX_HOME:-$HOME/.codex}/skills" ;;
    gemini)   echo "$HOME/.gemini/skills" ;;
    agents)   echo "$HOME/.agents/skills" ;;
  esac
}

project_dir() {
  case "$1" in
    claude)   echo "$PROJECT/.claude/skills" ;;
    opencode) echo "$PROJECT/.opencode/skills" ;;
    codex|agents) echo "$PROJECT/.agents/skills" ;;
    gemini)   echo "$PROJECT/.gemini/skills" ;;
  esac
}

place() {
  local dest="$1/$NAME"
  if [[ "$ACTION" == "uninstall" ]]; then
    [[ -e "$dest" || -L "$dest" ]] && rm -rf "$dest" && echo "  removed    $dest"
    return
  fi
  mkdir -p "$1"
  rm -rf "$dest"
  if [[ "$MODE" == "link" ]]; then ln -s "$SRC" "$dest"; else cp -R "$SRC" "$dest"; fi
  echo "  installed  $dest ($MODE)"
}

declare -A seen=()
for a in "${AGENTS[@]}"; do
  if [[ -n "$PROJECT" ]]; then d="$(project_dir "$a")"; else d="$(global_dir "$a")"; fi
  [[ -n "${seen[$d]:-}" ]] && continue
  seen[$d]=1
  echo "[$a]"
  place "$d"
done

# For agents without skill support (Cursor, Aider, Copilot…): a section in AGENTS.md
if [[ -n "$PROJECT" && "$ACTION" == "install" ]]; then
  f="$PROJECT/AGENTS.md"
  marker="<!-- skill:$NAME -->"
  if ! grep -qs "$marker" "$f"; then
    cat >> "$f" <<EOF

$marker
## Software engineering
For any design, implementation, refactoring or review task, read and apply
\`.agents/skills/$NAME/SKILL.md\` (SOLID, design patterns, architecture, testing).
Only load files from \`.agents/skills/$NAME/references/\` when the task calls for them.
EOF
    echo "[AGENTS.md] section added to $f"
  fi
  [[ -e "$PROJECT/.agents/skills/$NAME" ]] || { echo "[agents]"; place "$PROJECT/.agents/skills"; }
fi

echo "Done. Restart your agent so it picks up the skill."
