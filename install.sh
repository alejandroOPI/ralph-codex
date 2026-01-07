#!/bin/bash
# Ralph for Codex - Installer

set -e

INSTALL_DIR="$HOME/.codex-ralph"
BIN_DIR="$HOME/.local/bin"

echo "Installing Ralph for Codex..."

# Create directories
mkdir -p "$INSTALL_DIR" "$BIN_DIR"

# Copy files
cp codex_loop.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/codex_loop.sh"

# Create wrapper scripts
cat > "$BIN_DIR/codex-ralph" << 'WRAPPER'
#!/bin/bash
exec "$HOME/.codex-ralph/codex_loop.sh" "$@"
WRAPPER
chmod +x "$BIN_DIR/codex-ralph"

# Setup script
cat > "$BIN_DIR/codex-ralph-setup" << 'SETUP'
#!/bin/bash
# Create a new Ralph project

if [[ -z "$1" ]]; then
  echo "Usage: codex-ralph-setup <project-name>"
  exit 1
fi

PROJECT="$1"
mkdir -p "$PROJECT"
cd "$PROJECT"

# Create PROMPT.md template
cat > PROMPT.md << 'PROMPT'
# Project: [NAME]

## Desired End State
[Describe what the finished product looks like - be specific!]

## Technical Requirements
- Language/Framework: [X]
- Key dependencies: [only what's necessary]
- Target environment: [browser/node/etc]

## Files to Create
List each file and its purpose:
- index.html - main entry point
- style.css - styling
- app.js - application logic

## Acceptance Criteria
All of these must be true for completion:
- [ ] Criteria 1
- [ ] Criteria 2
- [ ] Criteria 3

## Constraints
- No unnecessary dependencies
- Keep it simple
- [Other constraints]

## Completion Signal
When ALL acceptance criteria are met, output exactly:
RALPH_DONE

If you cannot proceed, output:
RALPH_STUCK: [explain why]
PROMPT

mkdir -p logs
git init -q
git add -A
git commit -q -m "Initial Ralph project setup"

echo "✅ Created Ralph project: $PROJECT"
echo ""
echo "Next steps:"
echo "  1. Edit PROMPT.md with your specs"
echo "  2. Run: codex-ralph"
echo "  3. Wait for RALPH_DONE"
SETUP
chmod +x "$BIN_DIR/codex-ralph-setup"

# Add to PATH if needed
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo "Add to your shell config:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "✅ Installed!"
echo ""
echo "Commands:"
echo "  codex-ralph-setup <name>  - Create new project"
echo "  codex-ralph               - Run Ralph loop"
echo "  codex-ralph --timeout 60  - Run with 60min timeout"
echo "  codex-ralph --loops 50    - Run max 50 loops"
