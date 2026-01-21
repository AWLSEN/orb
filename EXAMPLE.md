# Orbiter Usage Example

## Scenario: Two developers working on the same project

### Developer A (on laptop)

```bash
# Install orbiter
cd orbiter
./install.sh

# Configure sync location (shared Dropbox folder)
orb config set-sync-path ~/Dropbox/orbiter-sync

# Add the spoq-web-apis namespace
orb config add spoq-web-apis

# Check status
orb status

# Push your plans
orb push
```

**Output:**
```
Pushing plans...
  spoq-web-apis
✓ Pushed 1 namespace(s)
```

### Developer B (on desktop)

```bash
# Install orbiter
cd orbiter
./install.sh

# Configure same sync location
orb config set-sync-path ~/Dropbox/orbiter-sync

# Add the same namespace
orb config add spoq-web-apis

# Pull plans from Developer A
orb pull
```

**Output:**
```
Pulling plans...
  spoq-web-apis
✓ Pulled 1 namespace(s)
```

Now Developer B has all of Developer A's plans!

### Making changes

**Developer A creates a new plan:**
```bash
# (In Claude Code, run /nova to create a plan)
# Plan created: plan-20260121-1800

# Push the new plan
orb push
```

**Developer B syncs:**
```bash
# Pull latest plans
orb pull

# Now Developer B has the new plan
```

## Current Behavior

- **Namespace selection**: Only configured namespaces are synced
- **Conflict resolution**: Newest timestamp wins (simple for now)
- **Manual sync**: You run `orb push` and `orb pull` manually
- **Board merge**: Plans from both devices are combined, duplicates removed

## What's NOT included (yet)

- Automatic background sync
- Real-time updates
- Conflict resolution UI
- Lock files to prevent simultaneous edits
- Plan modification (merge/split/reorder)
- Git orchestration
- Queue management

## Sync Locations

You can use any shared folder:
- **Dropbox**: `~/Dropbox/orbiter-sync`
- **Google Drive**: `~/Google Drive/orbiter-sync`
- **Network drive**: `/Volumes/SharedDrive/orbiter-sync`
- **Local network**: `/mnt/nas/orbiter-sync`

## Multiple Namespaces

```bash
# Add multiple projects
orb config add spoq-web-apis
orb config add spoq-cli
orb config add my-other-project

# Push all at once
orb push

# List configured namespaces
orb config list
```

## Removing Namespaces

```bash
# Stop syncing a namespace
orb config remove spoq-cli
```

## Checking Status

```bash
# See current configuration and remote state
orb status
```

**Output:**
```
Orbiter Status
  Version: 0.1.0-barebones
  Sync path: /Users/dev/Dropbox/orbiter-sync

Configured namespaces:
  spoq-web-apis
  spoq-cli

Remote namespaces:
  spoq-web-apis
    Last push: 2026-01-21T18:30:00Z by dev@macbook
  spoq-cli
    Last push: 2026-01-21T18:25:00Z by dev@desktop
```
