# Orb Server Mode Guide

## How Orb Syncing Works

Orb uses HTTP-based server sync. One person runs a server, everyone else connects to it.

## Server Mode Usage

### On Server Machine (Developer A)

```bash
# Start server with public URL
orb serve --public

# Output:
# Starting Orb Server
#   Port: 3000
#   Host: 127.0.0.1
#
# Starting ngrok tunnel...
# ✓ Public URL: https://abc123.ngrok.io
#
# Share this URL with your team:
#   orb config set-sync-path https://abc123.ngrok.io
```

### On Client Machines (Developer B, C, D...)

```bash
# Use the URL from the server
orb config set-sync-path https://abc123.ngrok.io

# Add namespaces
orb config add spoq-web-apis
orb config add spoq-cli

# Push/pull as normal
orb push
orb pull
```

## Server Options

### Basic Server (Local Network Only)
```bash
orb serve
# Accessible at: http://127.0.0.1:3000
# Only works on same machine
```

### Public Server (Internet Access)
```bash
orb serve --public
# Auto-starts ngrok
# Gives you: https://xyz.ngrok.io
```

### Custom Port
```bash
orb serve --port 8080 --public
# Uses port 8080 instead of 3000
```

### Custom Host (LAN Access)
```bash
orb serve --host 0.0.0.0
# Accessible on local network at: http://192.168.x.x:3000
```

## Why Server Mode?

- ✅ Works for remote teams (different networks)
- ✅ Centralized plan storage
- ✅ Server host sees all plans in Nova/Pulsar
- ✅ Simple HTTP-based sync

## ngrok Setup

### Install ngrok
```bash
# macOS
brew install ngrok

# Linux
snap install ngrok

# Or download from
https://ngrok.com/download
```

### First-time Setup
```bash
# Sign up at ngrok.com (free)
# Get your auth token
ngrok config add-authtoken <your_token>

# Now you can use orb serve --public
orb serve --public
```

### Free vs Paid ngrok

**Free:**
- ✅ 1 concurrent tunnel
- ✅ Random URL each time
- ✅ Good for testing

**Paid ($8/mo):**
- ✅ Custom domains
- ✅ Persistent URLs
- ✅ More tunnels

For testing, free is fine!

## Architecture

```
┌─────────────────┐
│  Dev A's Mac    │
│  orb serve      │ ← Runs the server
│  --public       │
└────────┬────────┘
         │
         │ ngrok tunnel
         ▼
   https://abc123.ngrok.io
         │
         │
    ┌────┴────┬────────┬────────┐
    │         │        │        │
┌───▼──┐  ┌──▼───┐ ┌──▼───┐ ┌──▼───┐
│Dev B │  │Dev C │ │Dev D │ │Dev E │
│push  │  │pull  │ │push  │ │pull  │
│pull  │  │push  │ │pull  │ │push  │
└──────┘  └──────┘ └──────┘ └──────┘
```

## Workflow Examples

### Scenario 1: Remote Team
```bash
# Team lead (Dev A) starts server
orb serve --public
# Gets: https://team-orbiter.ngrok.io

# Shares URL in Slack
# Everyone configures:
orb config set-sync-path https://team-orbiter.ngrok.io
orb config add spoq-web-apis
orb push
```

### Scenario 2: Office Network
```bash
# One dev runs server on office machine
orb serve --host 0.0.0.0 --port 3000

# Others use local IP
orb config set-sync-path http://192.168.1.100:3000
orb push
orb pull
```

### Scenario 3: VPS Server
```bash
# SSH to VPS
ssh user@your-vps.com

# Install orbiter
git clone <orbiter-repo>
cd orbiter && ./install.sh

# Run server
orb serve --host 0.0.0.0 --port 3000

# Team uses VPS domain
orb config set-sync-path http://your-vps.com:3000
```

## Server Data Location

When you run the server, team plans sync directly to your local `~/comms/plans/` directory:
```
~/comms/plans/
├── spoq-web-apis/
│   ├── board.json (filtered to active/queued)
│   ├── active/
│   └── queued/
└── spoq-cli/
    ├── board.json (filtered to active/queued)
    ├── active/
    └── queued/
```

This means as server host, you can see all team plans in Nova/Pulsar!

## Stopping the Server

```bash
# Press Ctrl+C in the terminal running orb serve
^C

# Output:
# Stopping server...
# ✓ Server stopped
```

## Troubleshooting

### ngrok not found
```bash
# Install it
brew install ngrok   # macOS
snap install ngrok   # Linux

# Or download from ngrok.com
```

### Port already in use
```bash
# Use different port
orb serve --port 3001 --public
```

### Can't access server URL
```bash
# Check server is running
curl http://localhost:3000/health

# Should return: {"status": "ok", "version": "0.1.0-barebones"}
```

### ngrok tunnel not starting
```bash
# Make sure you added auth token
ngrok config add-authtoken <token>

# Check ngrok dashboard
http://localhost:4040
```

## Switching Servers

You can switch between different servers anytime:

```bash
# Connect to dev server
orb config set-sync-path https://abc123.ngrok.io
orb push

# Switch to production server
orb config set-sync-path https://xyz456.ngrok.io
orb push
```

## Security Notes

### v0.1 (Current):
- ❌ No authentication
- ❌ No encryption (beyond ngrok's HTTPS)
- ❌ No access control

**Use only with trusted team members!**

### Future (v0.2+):
- ✅ API key authentication
- ✅ User accounts
- ✅ Namespace permissions
- ✅ End-to-end encryption

## Next Steps

- Try `orb serve --public` now!
- Share the URL with a teammate
- Both push/pull plans
- See them sync instantly!

Later, we'll build "Orb Cloud" (hosted service) so you don't need to run your own server.
