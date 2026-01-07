# Ralph Upgrade Proposal

## Learnings from the Articles

### Key Insights from Geoff Huntley & HumanLayer

1. **The OG Ralph is dead simple:**
```bash
while :; do cat PROMPT.md | npx --yes @sourcegraph/amp ; done
```

2. **The point is NOT "run forever"** - it's about carving off small bits of work into independent context windows

3. **Overbaking phenomenon:** If you leave ralph running too long, you get bizarre emergent behavior (post-quantum crypto support lol)

4. **Declarative specs > imperative instructions:** Ralph works because the PROMPT.md is a desired state, not a todo list

5. **If specs are bad, results are meh:** The quality of PROMPT.md determines everything

6. **Code is cheap:** If you get merge conflicts, just re-run ralph on fresh code - don't try to rebase

7. **Make change sets manageable:** Run ONCE per night on a cron, merge small iterations over time

8. **The Anthropic plugin sucks:** It misses the key point, uses weird state tracking, breaks easily

---

## How I (Clawdius) Should Use Ralph

### When to Use Ralph
- **Greenfield projects** with well-defined specs (like the coffee app)
- **Large refactors** with clear coding standards
- **Spec-driven development** where the end state is known
- **Overnight autonomous work** while Alejandro sleeps

### When NOT to Use Ralph
- **Exploration/iteration** - use regular Claude/Codex instead
- **Unclear requirements** - figure those out first
- **Quick fixes** - overkill for small changes

### My Ralph Workflow
1. **Alejandro gives me a project idea**
2. **I write the PROMPT.md** (declarative spec, desired state)
3. **I run Ralph and monitor** - but DON'T babysit
4. **If it fails badly, DELETE everything and re-spec** (don't debug garbage)
5. **When done, verify and deploy**

---

## Proposed Changes to ralph-codex

### Problem: Current Implementation is Over-Engineered
- Circuit breaker logic
- Response analyzer
- Exit signal detection
- Rate limiting
- Too many moving parts

### Solution: Return to Simplicity

**New `codex_loop.sh`:**
```bash
#!/bin/bash
# Ralph for Codex - Simple version

PROMPT_FILE="${1:-PROMPT.md}"
MAX_LOOPS="${2:-100}"
TIMEOUT_MINS="${3:-30}"

mkdir -p logs

for i in $(seq 1 $MAX_LOOPS); do
  echo "[$(date)] Loop $i starting..."
  
  # Run Codex with timeout
  gtimeout ${TIMEOUT_MINS}m codex exec --skip-git-repo-check --full-auto \
    "$(cat $PROMPT_FILE)" \
    2>&1 | tee "logs/loop_${i}_$(date +%Y%m%d_%H%M%S).log"
  
  EXIT_CODE=$?
  
  # If Codex says it's done, stop
  if grep -q "RALPH_DONE" "logs/loop_${i}"*.log 2>/dev/null; then
    echo "[$(date)] Ralph signaled completion"
    break
  fi
  
  # Brief pause between loops
  sleep 5
done

echo "[$(date)] Ralph finished after $i loops"
```

### Key Changes:
1. **Remove circuit breaker** - just let it run
2. **Remove response analyzer** - trust Codex output
3. **Add RALPH_DONE signal** - simple completion detection
4. **Longer timeout** - 30 mins default (can go hours)
5. **DELETE on fail policy** - if garbage, nuke and re-spec

### PROMPT.md Template:
```markdown
# Project: [NAME]

## Desired End State
[Describe what the finished product looks like]

## Technical Specs
- Language: [X]
- Framework: [Y]
- No dependencies except: [Z]

## Files to Create
- file1.js - [purpose]
- file2.css - [purpose]

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## On Completion
When ALL criteria are met, output "RALPH_DONE" on a line by itself.

## If Stuck
If you cannot proceed, output "RALPH_STUCK: [reason]" and stop.
```

---

## Skill Update for Clawdius

### New SKILL.md
```markdown
# Ralph Codex Skill

## When to Invoke
- User asks for autonomous overnight coding
- User provides detailed project specs
- User says "let Ralph handle it"

## Workflow
1. Create project directory: `codex-ralph-setup <name>`
2. Write PROMPT.md with declarative specs
3. Run: `codex-ralph --timeout 60` (or longer)
4. Monitor occasionally with `codex-monitor`
5. If garbage output: DELETE and rewrite specs
6. If good output: verify and deploy

## Key Principles
- **Specs determine quality** - spend 80% on PROMPT.md
- **Don't babysit** - let it run for hours
- **Delete failures** - don't debug, re-spec
- **Small batches** - better than one mega-run

## Timeout Guidance
- Simple app: 30 mins
- Medium project: 1-2 hours
- Complex refactor: 4-8 hours
- Full system: overnight (8+ hours)
```

---

## Action Items

1. [ ] Simplify `codex_loop.sh` (remove over-engineering)
2. [ ] Add RALPH_DONE signal support
3. [ ] Update skill to reflect new philosophy
4. [ ] Create better PROMPT.md templates
5. [ ] Add `--timeout` flag for hours-long runs
6. [ ] Test with a real overnight project

---

## Philosophy Summary

> "The point is not the 5-line bash loop. The point is **dumb things can work surprisingly well**, so what could we expect from a smart version of the thing?"

Ralph is art. It's chaos embraced. It's letting go of control and trusting the process.

The specs are everything. The loop is nothing.
