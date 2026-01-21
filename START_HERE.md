# 🚀 START HERE

Welcome to Orbiter v0.1.0-barebones!

## What is this?

A simple plan sync for Starry Night. Share Nova/Pulsar plans with your team using `orb push` and `orb pull`.

## Getting Started in 3 Steps

### 1. Install (30 seconds)
```bash
./install.sh
```

### 2. Configure (1 minute)
```bash
# Set your team's shared folder (Dropbox, Google Drive, etc.)
orb config set-sync-path ~/Dropbox/orbiter-sync

# Add namespaces you want to sync
orb config add spoq-web-apis
orb config add spoq-cli
```

### 3. Use (forever)
```bash
orb push    # Share your plans with team
orb pull    # Get team's plans
```

That's it!

## What to Read

Pick based on your goal:

### Just want to use it?
→ Read **QUICKSTART.md** (2 minutes)

### Want to understand how it works?
→ Read **README.md** (5 minutes)

### Want to see real examples?
→ Read **EXAMPLE.md** (3 minutes)

### Want to see it in action?
→ Read **DEMO.md** (5 minutes)

### Want to know what's next?
→ Read **ROADMAP.md** (2 minutes)

### Want technical details?
→ Read **SUMMARY.md** (5 minutes)

## Quick Commands

```bash
orb push              # Share your plans
orb pull              # Get team's plans
orb status            # Check sync status
orb config list       # Show namespaces
orb help              # Show all commands
```

## How It Works

```
Your Machine       Shared Folder        Teammate
────────────       ─────────────        ────────
~/comms/plans/ →   Dropbox/Drive   →    ~/comms/plans/
               ←   /orbiter-sync   ←
```

1. You create plans with Nova/Pulsar in Claude Code
2. Run `orb push` to copy plans to shared folder
3. Teammate runs `orb pull` to get your plans
4. They can now execute/review your plans

## What Gets Synced

From `~/comms/plans/<namespace>/`:
- ✅ `board.json` - plan metadata
- ✅ `active/` - active plans
- ✅ `queued/` - queued plans

Not synced:
- ❌ `archived/` - too large
- ❌ `review/` - local only

## Philosophy

**Start simple.** Manual push/pull is enough. We can add auto-sync, real-time updates, and servers later.

**Git-like.** Familiar commands for developers.

**File-based.** Works with tools you already use (Dropbox, Drive).

## Need Help?

1. Run `orb help` for command reference
2. Check README.md for full documentation
3. Read QUICKSTART.md for setup guide
4. See EXAMPLE.md for usage scenarios

## Already Installed?

Check if it's working:
```bash
orb version    # Should show: v0.1.0-barebones
orb status     # Should show your config
```

## What's Next?

After you install and start using it:
1. **Use it daily** - Get real feedback
2. **Learn** - What features do you actually need?
3. **Evolve** - Build v0.2 based on usage

Read ROADMAP.md to see the evolution path.

---

**Ready?** → Run `./install.sh` and start syncing! 🚀
