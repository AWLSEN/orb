# Orbiter Quick Start

Get plan syncing working in 2 minutes.

## Install

```bash
cd orbiter
./install.sh
```

## Setup (Team)

Everyone on the team needs a shared folder. Pick one:

### Option 1: Dropbox
```bash
orb config set-sync-path ~/Dropbox/orbiter-sync
```

### Option 2: Google Drive
```bash
orb config set-sync-path ~/Google\ Drive/orbiter-sync
```

### Option 3: Network Drive
```bash
orb config set-sync-path /Volumes/TeamDrive/orbiter-sync
```

## Configure Namespaces

Add the projects you want to sync:

```bash
orb config add spoq-web-apis
orb config add spoq-cli
```

List your configured namespaces:
```bash
orb config list
```

## Sync Plans

**Push your plans:**
```bash
orb push
```

**Pull plans from teammates:**
```bash
orb pull
```

**Check status:**
```bash
orb status
```

## Typical Workflow

1. **Morning**: `orb pull` - get latest plans from team
2. **Work**: Create/execute plans with Nova/Pulsar
3. **Share**: `orb push` - share your plans with team
4. **End of day**: `orb pull` - sync final updates

## Tips

- Run `orb pull` before starting work
- Run `orb push` after creating new plans
- Run `orb status` to see what's synced
- Plans merge automatically (newest wins)

## Troubleshooting

**Sync path not found?**
```bash
# Check your config
orb status

# Set it again
orb config set-sync-path ~/Dropbox/orbiter-sync
```

**Namespace not found?**
```bash
# List available namespaces
ls ~/comms/plans/

# Add the one you want
orb config add <namespace>
```

**Want to start fresh?**
```bash
# Remove config
rm -rf ~/.orb

# Run orb again to reinitialize
orb status
```

## What Gets Synced

From each namespace:
- `board.json` - plan metadata
- `active/` - active plans
- `queued/` - queued plans

What's NOT synced:
- `archived/` - archived plans (too large)
- `review/` - review plans (local only)
- Git commits (use git for code)

## Next Steps

- Read [EXAMPLE.md](EXAMPLE.md) for detailed scenarios
- Check [ROADMAP.md](ROADMAP.md) for future features
- See [README.md](README.md) for full documentation
