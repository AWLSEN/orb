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
orb config set-sync-path https://abc123.ngrok.io
orb config add spoq-web-apis
orb push
orb pull
```

Done! Your plans are synced.

## What It Does

Syncs Nova/Pulsar plans from `~/comms/plans/` across team members:

- ✅ `board.json` - Plan metadata
- ✅ `active/` - Active plans
- ✅ `queued/` - Queued plans

Each namespace (project) has its own isolated plan storage.

## Commands

```bash
orb serve --public              # Start server with public URL
orb config set-sync-path <url>  # Connect to server
orb config add <namespace>      # Add namespace to sync
orb push                        # Push your plans
orb pull                        # Pull team's plans
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

## Requirements

Auto-installed by `install.sh`:
- `jq` - JSON processing
- `rsync` - File syncing
- `python3` - Server mode
- `ngrok` - Public URL (optional)

## Documentation

- **[START_HERE.md](START_HERE.md)** - Begin here (2 min)
- **[QUICKSTART.md](QUICKSTART.md)** - Setup guide
- **[SERVER_GUIDE.md](SERVER_GUIDE.md)** - Server mode details
- **[EXAMPLE.md](EXAMPLE.md)** - Real scenarios
- **[ROADMAP.md](ROADMAP.md)** - Future plans

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

## Current Version

**v0.1.0-barebones**
- Manual push/pull (no auto-sync)
- Server-based sync with ngrok
- Namespace filtering
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
