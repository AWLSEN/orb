# Orbiter Demo

## What We Built

A barebones plan syncing system for Starry Night (Nova/Pulsar). Think "git for plans" but simpler.

## The Problem

You're working with team members on Starry Night plans:
- Developer A creates a plan on their MacBook
- Developer B wants to see/execute that plan on their iMac
- How do they sync plans without manually copy-pasting?

## The Solution

```bash
# Developer A (MacBook)
orb config add spoq-web-apis
orb push                          # Plans → Dropbox

# Developer B (iMac)  
orb config add spoq-web-apis
orb pull                          # Dropbox → Plans
```

Done. Plans are synced.

## Live Demo

### Setup

```bash
# Install
cd orbiter
./install.sh

# Configure sync folder (team picks one location)
orb config set-sync-path ~/Dropbox/orbiter-sync

# Each dev adds namespaces they want
orb config add spoq-web-apis
orb config add spoq-cli
```

### Daily Workflow

```bash
# Morning: get latest plans
orb pull

# Work: create plans with Nova/Pulsar in Claude Code
# Plans are created in ~/comms/plans/spoq-web-apis/

# Share: push your plans
orb push

# Later: get updates from team
orb pull
```

### What Gets Synced

From each namespace (`~/comms/plans/<namespace>/`):
- ✅ `board.json` - plan metadata
- ✅ `active/` - active plans being executed
- ✅ `queued/` - plans waiting to run

Not synced:
- ❌ `archived/` - completed plans (too large)
- ❌ `review/` - review plans (local only)

### Real Example

```bash
# Check status
$ orb status
Orbiter Status
  Version: 0.1.0-barebones
  Sync path: /tmp/orbiter-test-sync

Configured namespaces:
  - spoq-web-apis

# Push plans
$ orb push
Pushing plans...
  spoq-web-apis
✓ Pushed 1 namespace(s)

# Pull plans
$ orb pull
Pulling plans...
  spoq-web-apis
✓ Pulled 1 namespace(s)
```

## Architecture

```
┌─────────────────┐
│  Your Machine   │
│                 │
│ ~/comms/plans/  │
│  └─ spoq-web-*  │
└────────┬────────┘
         │
         │ orb push
         ▼
┌─────────────────────┐
│  Shared Folder      │
│  (Dropbox/Drive)    │
│                     │
│  orbiter-sync/      │
│   └─ spoq-web-*     │
└──────────┬──────────┘
           │
           │ orb pull
           ▼
    ┌──────────────┐
    │  Teammate    │
    │              │
    │ comms/plans/ │
    │  └─ spoq-*   │
    └──────────────┘
```

## Key Features

### 1. Namespace Filtering
Only sync projects you care about:
```bash
orb config add spoq-web-apis    # Sync this
orb config add spoq-cli         # And this
# Don't add other namespaces - they won't sync
```

### 2. Conflict Resolution
Newest file wins automatically:
- Developer A edits plan-001 at 2pm
- Developer B edits plan-001 at 3pm
- When A pulls, B's version wins (it's newer)

### 3. Git-like Commands
Familiar workflow:
- `orb push` = git push
- `orb pull` = git pull
- `orb status` = git status

### 4. Works with Existing Tools
Use any shared folder:
- Dropbox
- Google Drive
- Network drive
- Cloud storage mount

No server needed!

## What's NOT Included (Yet)

- ❌ Auto-sync (manual push/pull only)
- ❌ Plan diffs/merging
- ❌ Real-time updates
- ❌ Conflict resolution UI
- ❌ Plan history/versioning

**This is intentional.** We're solving the core problem first: basic plan syncing.

## Evolution Path

### v0.1 - Barebones (NOW)
Manual `orb push/pull` with shared folder

### v0.2 - Auto-sync
Background daemon watches for changes, auto-syncs

### v0.3 - Server
Optional server for teams without shared folder

### v0.4 - Real-time
WebSocket updates, instant plan sync

### v0.5 - Advanced
Plan diffs, merge tools, conflict resolution UI

### v1.0 - Full Vision
Everything from the PDF - queue management, git orchestration, etc.

## Commands Reference

```bash
# Config
orb config set-sync-path <path>   # Set shared folder
orb config add <namespace>         # Add namespace
orb config remove <namespace>      # Remove namespace
orb config list                    # List namespaces

# Sync
orb push                          # Push to shared folder
orb pull                          # Pull from shared folder
orb status                        # Show status

# Info
orb help                          # Show help
orb version                       # Show version
```

## Files Created

```
orbiter/
├── orb                # Main CLI (390 lines)
├── install.sh         # Installation script
├── test.sh           # Test suite
├── README.md         # Full documentation
├── QUICKSTART.md     # Quick start guide
├── EXAMPLE.md        # Usage examples
├── ROADMAP.md        # Future plans
├── DEMO.md           # This file
└── .gitignore        # Git ignore

~/.orbiter/
├── config.json       # User config
└── bin/
    └── orb          # Installed binary
```

## Try It Now

```bash
# 1. Install
cd orbiter
./install.sh

# 2. Set sync path
orb config set-sync-path ~/Dropbox/orbiter-sync

# 3. Add a namespace
orb config add spoq-web-apis

# 4. Push plans
orb push

# 5. Check status
orb status
```

That's it! You now have plan syncing working.

## Team Setup

1. **Choose shared folder** - Everyone uses same path
   - Dropbox: `~/Dropbox/orbiter-sync`
   - Google Drive: `~/Google Drive/orbiter-sync`

2. **Everyone installs**
   ```bash
   cd orbiter && ./install.sh
   ```

3. **Everyone configures**
   ```bash
   orb config set-sync-path ~/Dropbox/orbiter-sync
   orb config add spoq-web-apis
   ```

4. **Start syncing**
   ```bash
   orb pull    # Morning: get latest
   orb push    # After work: share updates
   ```

## Philosophy

**Start simple.** Manual push/pull solves the core problem: getting plans from one machine to another.

**Git-like.** Developers already know git. Same mental model.

**File-based.** Works with tools teams already use (Dropbox, Drive).

**Evolution path.** Clear roadmap to add features as needed.

## Success Criteria

✅ Team can sync plans across machines
✅ Works with existing tools (no new infrastructure)
✅ Simple commands (`push`/`pull`)
✅ Namespace filtering (sync only what you need)
✅ Basic conflict resolution (newest wins)

All achieved in v0.1.0-barebones!

## Next Steps

1. **Use it** - Get real feedback from daily use
2. **Learn** - What features are actually needed?
3. **Evolve** - Add auto-sync, then server, then real-time

Start simple. Ship fast. Iterate based on real usage.
