# Orb - Plan Sync for Starry Night

Sync Nova/Pulsar plans across your team. Think "git for plans" but simpler.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/awlsen/orb/main/install.sh | bash
```

Or clone and install:

```bash
git clone https://github.com/awlsen/orb.git
cd orb
./install.sh
```

## Quick Start

**One person runs the server:**
```bash
orb serve --public
# Output: https://abc123.ngrok.io
```

**Everyone else connects:**
```bash
# See what namespaces you have
orb list

# Connect to server
orb config set-sync-path https://abc123.ngrok.io

# Add namespaces to sync
orb config add spoq-web-apis
orb config add spoq-cli

# Push and pull plans
orb push
orb pull
```

Done! Your plans are synced.

## What It Does

Syncs Nova/Pulsar plans from `~/comms/plans/` across team members:

- ✅ `board.json` - Plan metadata (filtered to active/queued only)
- ✅ `active/` - Active plans
- ✅ `queued/` - Queued plans

**What's NOT synced:**
- ❌ `archived/` - Completed plans (stay local)
- ❌ `review/` - Review plans (stay local)

Each namespace (project) has its own isolated plan storage.

## Commands

```bash
orb list                        # List all available namespaces
orb serve --public              # Start server with public URL
orb config set-sync-path <url>  # Connect to server
orb config add <namespace>      # Add namespace to sync
orb config remove <namespace>   # Remove namespace (stop syncing, keep files)
orb config list                 # List configured namespaces
orb delete <namespace>          # Delete namespace completely (removes files!)
orb push [namespace]            # Push your plans (all or specific)
orb pull [namespace]            # Pull team's plans (all or specific)
orb status                      # Check sync status
```

## How It Works

```
Developer A               Server                 Developer B
───────────              ────────               ───────────
orb serve --public  →    ngrok tunnel    ←      orb push
   ↓                     https://...            orb pull
Public URL shared   →    with team      →       sync plans
```

One person runs `orb serve --public`, shares the URL, everyone syncs.

**Server host sees all plans:** When running the server, team plans sync directly to your `~/comms/plans/` directory, visible in Nova/Pulsar.

## Requirements

Auto-installed by `install.sh`:
- `jq` - JSON processing
- `rsync` - File syncing
- `python3` - Server mode
- `ngrok` - Public URL (optional)

## Documentation

- **[START_HERE.md](docs/START_HERE.md)** - Begin here (2 min)
- **[QUICKSTART.md](docs/QUICKSTART.md)** - Setup guide
- **[SERVER_GUIDE.md](docs/SERVER_GUIDE.md)** - Server mode details
- **[EXAMPLE.md](docs/EXAMPLE.md)** - Real scenarios
- **[ROADMAP.md](docs/ROADMAP.md)** - Future plans

## Examples

### Team Workflow
```bash
# Morning: get latest
orb pull

# Work: create/execute plans with Nova/Pulsar
# Plans stored in ~/comms/plans/

# Share: push completed plans
orb push
```

### Namespace Filtering
```bash
# Only sync specific projects
orb config add spoq-web-apis    # Sync this
orb config add spoq-cli         # And this
# Don't add other namespaces    # They won't sync
```

### Individual Namespace Sync
```bash
# Push/pull specific namespaces
orb push spoq-web-apis          # Just push this project
orb pull spoq-cli               # Just pull this project

# Or sync all configured namespaces
orb push                        # Push everything
orb pull                        # Pull everything
```

## Current Version

**v0.1.0-barebones**
- HTTP-based push/pull with server sync
- Individual or bulk namespace operations
- Namespace filtering
- Server syncs to `~/comms/plans/` (visible in Nova/Pulsar)
- Handles both array and object `board.json` formats
- Simple conflict resolution (newest wins)

## Roadmap

- **v0.2** - Auto-sync daemon
- **v0.3** - Hosted Orb Cloud service
- **v0.4** - Real-time WebSocket sync
- **v0.5** - Plan diffs and merge tools

See [ROADMAP.md](ROADMAP.md) for details.

## Philosophy

Start simple. Manual push/pull solves the core problem: syncing plans across machines. We can add automation, real-time updates, and advanced features based on real usage.

## License

MIT

## Contributing

This is v0.1.0-barebones - we're intentionally keeping it minimal to:
1. Get plan syncing working NOW
2. Learn what features are actually needed
3. Evolve based on real usage

Issues and PRs welcome!
