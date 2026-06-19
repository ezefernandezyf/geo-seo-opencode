#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO opencode Skill Uninstaller
# ============================================================

OPENCODE_DIR="${HOME}/.config/opencode"
SKILLS_DIR="${OPENCODE_DIR}/skills"
AGENTS_DIR="${OPENCODE_DIR}/agents"

# Detect if running via curl pipe (no interactive input available)
INTERACTIVE=true
if [ ! -t 0 ]; then
    INTERACTIVE=false
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure unmatched globs expand to nothing
shopt -s nullglob

echo ""
echo -e "${YELLOW}GEO-SEO opencode Skill Uninstaller${NC}"
echo ""
echo "This will remove the following:"
echo ""

# List what will be removed
[ -d "$SKILLS_DIR/geo" ] && echo "  → ${SKILLS_DIR}/geo/"
for skill_dir in "$SKILLS_DIR"/geo-*/; do
    [ -d "$skill_dir" ] && echo "  → ${skill_dir}"
done
[ -f "$AGENTS_DIR/geo-agent.md" ] && echo "  → ${AGENTS_DIR}/geo-agent.md"

echo ""
if [ "$INTERACTIVE" = true ]; then
    read -p "Are you sure you want to uninstall? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstall cancelled."
        exit 0
    fi
else
    echo -e "${YELLOW}Non-interactive mode — proceeding with uninstall...${NC}"
fi

echo ""

# Remove main skill
if [ -d "$SKILLS_DIR/geo" ]; then
    rm -rf "$SKILLS_DIR/geo"
    echo -e "${GREEN}✓ Removed main skill${NC}"
fi

# Remove sub-skills
for skill_dir in "$SKILLS_DIR"/geo-*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        rm -rf "$skill_dir"
        echo -e "${GREEN}✓ Removed ${skill_name}${NC}"
    fi
done

# Remove agent
if [ -f "$AGENTS_DIR/geo-agent.md" ]; then
    rm -f "$AGENTS_DIR/geo-agent.md"
    echo -e "${GREEN}✓ Removed geo-agent.md${NC}"
fi

echo ""
echo -e "${GREEN}GEO-SEO opencode skill has been uninstalled.${NC}"
echo ""
echo "Note: Python dependencies lived in an isolated venv inside the skill"
echo "directory, so they were removed automatically. Nothing to clean up on"
echo "your system Python."
echo ""
echo "Note: Restart opencode for the changes to take effect."
echo ""
echo "Note: If you added 'geo-agent' to your opencode.json task permissions,"
echo "remove that entry manually to keep your config clean."
echo ""
echo "Note: Prospect data at ~/.geo-prospects/ was not removed."
echo "To remove it manually:"
echo "  rm -rf ~/.geo-prospects"
echo ""
