# Ralph for Codex

A simple implementation of [Geoff Huntley's Ralph Wiggum technique](https://ghuntley.com/ralph/) for OpenAI Codex CLI.

> "The point is not the 5-line bash loop. The point is **dumb things can work surprisingly well**."

## Philosophy

1. **Specs determine quality** - Spend 80% of your time on PROMPT.md
2. **Don't babysit** - Let it run for hours
3. **Delete failures** - Don't debug garbage, re-spec instead
4. **Keep it simple** - The loop is nothing, the specs are everything

## Install

```bash
git clone https://github.com/alejandroOPI/ralph-codex
cd ralph-codex
./install.sh
```

## Usage

### Create a new project
```bash
codex-ralph-setup my-project
cd my-project
```

### Edit PROMPT.md
Write declarative specs. Describe the **desired end state**, not a todo list.

### Run Ralph
```bash
# Default: 30 min timeout, 100 loops max
codex-ralph

# Long-running project
codex-ralph --timeout 120  # 2 hour timeout per loop

# Overnight run
codex-ralph --timeout 480 --loops 20  # 8 hours, 20 loops
```

### Completion Signals

Your PROMPT.md should instruct Codex to output:
- `RALPH_DONE` - when all acceptance criteria are met
- `RALPH_STUCK: [reason]` - if it cannot proceed

Ralph will automatically stop when it sees these signals.

## PROMPT.md Template

```markdown
# Project: [NAME]

## Desired End State
[What does the finished product look like?]

## Technical Requirements
- Language/Framework: X
- Dependencies: only essential ones
- Target: browser/node/etc

## Files to Create
- file1.js - purpose
- file2.css - purpose

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## Completion Signal
When ALL criteria are met, output: RALPH_DONE
If stuck, output: RALPH_STUCK: [reason]
```

## Tips

- **Be specific** in your specs - vague specs = vague results
- **Include examples** of expected behavior
- **List constraints** explicitly (no deps, no external APIs, etc)
- **Test acceptance criteria** are measurable

## When to Use Ralph

✅ Greenfield projects with clear specs  
✅ Large refactors with defined standards  
✅ Overnight autonomous work  
✅ Spec-driven development  

❌ Exploration/iteration  
❌ Unclear requirements  
❌ Quick fixes  

## Based On

- [Ralph Wiggum Technique](https://ghuntley.com/ralph/) by Geoff Huntley
- [A Brief History of Ralph](https://www.humanlayer.dev/blog/brief-history-of-ralph) by HumanLayer
- [Cursed Lang](https://cursed-lang.org/) - a language built by Ralph

## License

MIT
