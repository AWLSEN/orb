# Orbiter Roadmap

## v0.1 - Barebones (Current)

**Goal: Solve the core problem - plan syncing**

✅ **Implemented:**
- Manual push/pull commands
- Namespace filtering
- File-based sync (Dropbox, network drives, etc.)
- Simple conflict resolution (newest wins)
- Board merging (combine plans, remove duplicates)
- Status reporting
- Config management

**Not Included:**
- Everything else from the vision document
- This is intentionally minimal to prove the concept

## v0.2 - Auto-sync (Next)

**Goal: Make it automatic**

- Background daemon process
- Watch for changes in `~/comms/plans/`
- Auto-push on changes
- Auto-pull on interval (e.g., every 30 seconds)
- Desktop notifications on conflicts

**Commands:**
```bash
orb daemon start
orb daemon stop
orb daemon status
```

## v0.3 - Better Conflict Handling

**Goal: Handle conflicts gracefully**

- Detect simultaneous edits
- Lock files during active work
- Conflict resolution UI
- Manual merge options
- Conflict history

**Features:**
- `.lock` files for active plans
- Conflict markers like git
- `orb resolve` command

## v0.4 - Plan Insights

**Goal: See what's happening across the team**

- Who's working on what
- Which files are being touched
- Plan dependencies
- Team activity dashboard

**Commands:**
```bash
orb team           # Show team member activity
orb conflicts      # List potential conflicts
orb dependencies   # Show plan dependencies
```

## v0.5 - Server Option (Optional)

**Goal: Real-time collaboration**

- WebSocket-based sync
- No shared folder needed
- Real-time plan updates
- Multi-team support

**Setup:**
```bash
orb server start --port 8080
orb config set-sync-mode server --url ws://localhost:8080
```

## v1.0 - Full Vision

Everything from the PDF:
- Plan modification (merge/split/reorder)
- Queue management
- Git orchestration
- Ownership assignment
- Conflict recovery
- Mixed team support

## Future Ideas

- Web UI for plan management
- Slack/Discord integration for notifications
- Plan analytics and metrics
- Time tracking per plan
- Integration with Nova/Pulsar/Pulse
- Plan templates and patterns
- Team roles and permissions

## Philosophy

Each version should:
1. **Work standalone** - don't ship half-baked features
2. **Solve a real problem** - each increment has clear value
3. **Stay simple** - resist feature creep
4. **Be backwards compatible** - don't break existing setups

We start with the absolute minimum (plan syncing) and evolve from there.
