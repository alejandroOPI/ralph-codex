# Codex Ralph

> **Fork of [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) adapted for OpenAI Codex CLI**

Autonomous AI development loop with intelligent exit detection and rate limiting, using OpenAI's Codex CLI instead of Claude Code.

## What's Different

This fork replaces Claude Code with Codex CLI:
- Uses `codex exec` for non-interactive execution
- Same loop logic, rate limiting, and circuit breaker
- Same PRD-based workflow

## Quick Start

### Install

```bash
git clone https://github.com/alejandroopi/ralph-codex.git
cd ralph-codex
./install.sh
```

This adds `codex-ralph`, `codex-monitor`, and `codex-ralph-setup` commands to your PATH.

### Create a Project

```bash
codex-ralph-setup my-project
cd my-project
```

### Run the Loop

```bash
codex-ralph --monitor    # With tmux monitoring
codex-ralph              # Without monitoring
```

## Features

- **Autonomous Loop** - Runs Codex until task is complete
- **Rate Limiting** - 100 calls/hour (configurable)
- **Circuit Breaker** - Stops on stuck loops or errors
- **Exit Detection** - Knows when project is done
- **tmux Monitoring** - Live dashboard

## Configuration

Edit `PROMPT.md` in your project with your requirements.

Options:
```bash
codex-ralph --calls 50        # Set max calls per hour
codex-ralph --timeout 30      # 30 min timeout per execution
codex-ralph --verbose         # Detailed progress
codex-ralph --reset-circuit   # Reset circuit breaker
```

## Requirements

- Codex CLI (`codex`)
- jq
- tmux (for monitoring)
- git

## Credits

Original: [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code)
Technique: [Geoffrey Huntley's Ralph Wiggum](https://ghuntley.com/ralph/)
