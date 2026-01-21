# File-Based vs Server-Based Sync Explained

## File-Based Mode (What Does This Mean?)

When you use "file-based" sync, orbiter **doesn't use any Dropbox/Google Drive API**.

Here's what actually happens:

### Step-by-step:

1. **You set a sync path to a LOCAL folder:**
   ```bash
   orb config set-sync-path ~/Dropbox/orbiter-sync
   ```

2. **Orbiter copies files to that folder:**
   ```bash
   orb push
   # Copies files from ~/comms/plans/spoq-web-apis/
   # To ~/Dropbox/orbiter-sync/spoq-web-apis/
   ```

3. **Dropbox app (running in background) sees new files and syncs them to cloud**
   - This happens automatically
   - Orbiter doesn't know or care about this
   - Orbiter just writes to a local folder

4. **Teammate's Dropbox app downloads files to their machine**
   - Again, automatic
   - Orbiter doesn't do this

5. **Teammate runs `orb pull`:**
   ```bash
   orb pull
   # Copies files from ~/Dropbox/orbiter-sync/spoq-web-apis/
   # To ~/comms/plans/spoq-web-apis/
   ```

### The Trick:

**Dropbox/Google Drive are just file sync services that keep a folder in sync across machines.**

Orbiter uses that folder, but **doesn't interact with Dropbox/Drive directly**.

### Diagram:

```
Your Machine:
  1. orb push
     ↓
  2. Copies to ~/Dropbox/orbiter-sync/
     ↓
  3. Dropbox app syncs to cloud (automatic)
     ↓
  4. Cloud syncs to teammate's machine (automatic)
     ↓
  5. Teammate's ~/Dropbox/orbiter-sync/ gets updated
     ↓
  6. orb pull
     ↓
  7. Copies to ~/comms/plans/
```

### You Could Use ANY Synced Folder:

```bash
# Dropbox
orb config set-sync-path ~/Dropbox/orbiter-sync

# Google Drive
orb config set-sync-path ~/Google\ Drive/orbiter-sync

# iCloud Drive
orb config set-sync-path ~/Library/Mobile\ Documents/com~apple~CloudDocs/orbiter-sync

# OneDrive
orb config set-sync-path ~/OneDrive/orbiter-sync

# Network drive
orb config set-sync-path /Volumes/TeamNAS/orbiter-sync

# Even a USB stick!
orb config set-sync-path /Volumes/USB/orbiter-sync
```

**Orbiter just copies files. The folder sync happens separately.**

## Server-Based Mode (The Alternative)

Instead of relying on Dropbox/Drive to sync a folder, you run your own server:

### Step-by-step:

1. **You run a server:**
   ```bash
   orb serve --public
   # Server at: https://abc123.ngrok.io
   ```

2. **Teammates connect to YOUR server:**
   ```bash
   orb config set-sync-path https://abc123.ngrok.io
   ```

3. **They push/pull directly to/from your server:**
   ```bash
   orb push  # HTTP POST to your server
   orb pull  # HTTP GET from your server
   ```

### Diagram:

```
Your Machine (Server):
  Running: orb serve --public
  URL: https://abc123.ngrok.io
  Data: ~/.orbiter/server/data/
     ↑           ↓
     │           │
  HTTP POST  HTTP GET
     │           │
     ↑           ↓
Teammate's Machine:
  orb push → sends to your server
  orb pull → gets from your server
```

## Which Should You Use?

### Use File-Based When:

✅ You already have Dropbox/Google Drive
✅ Small team (2-4 people)
✅ Don't want to run a server
✅ Sync can be delayed (not real-time)

**Example:**
```bash
orb config set-sync-path ~/Dropbox/orbiter-sync
orb push
# Dropbox syncs in background (takes 1-10 seconds)
# Teammate pulls when Dropbox finishes
```

### Use Server-Based When:

✅ Team is remote (no shared folder access)
✅ Want centralized control
✅ Need it to work from anywhere
✅ Don't want to use Dropbox/Drive

**Example:**
```bash
# You run server
orb serve --public
# Share URL: https://abc123.ngrok.io

# Team uses it
orb config set-sync-path https://abc123.ngrok.io
orb push  # Instant sync to your server
```

## Side-by-Side Comparison

| Feature | File-Based | Server-Based |
|---------|-----------|--------------|
| **Setup** | Point to Dropbox folder | Run `orb serve --public` |
| **Dependencies** | Dropbox/Drive installed | ngrok installed |
| **Sync Speed** | 1-10 seconds (Dropbox lag) | Instant (HTTP) |
| **Infrastructure** | None (uses Dropbox) | Your machine runs server |
| **Internet Required** | Yes (for Dropbox sync) | Yes (for HTTP) |
| **Works Remote** | Yes (if all have Dropbox) | Yes (ngrok tunnel) |
| **Data Location** | Dropbox cloud | Your machine |
| **Cost** | Free (if under Dropbox limits) | Free (ngrok free tier) |

## Can You Switch Between Them?

**Yes!** Anytime:

```bash
# Currently using file-based
orb config set-sync-path ~/Dropbox/orbiter-sync

# Switch to server-based
orb config set-sync-path https://abc123.ngrok.io

# Switch back
orb config set-sync-path ~/Dropbox/orbiter-sync
```

## Real-World Examples

### Example 1: Freelancer with 2 Machines

**Problem:** Sync plans between MacBook and iMac

**Solution:** File-based with iCloud
```bash
# On both machines
orb config set-sync-path ~/Library/Mobile\ Documents/com~apple~CloudDocs/orbiter-sync
orb config add my-project

# On MacBook
orb push

# On iMac (5 seconds later)
orb pull
```

### Example 2: Startup Team (5 people, remote)

**Problem:** Team across different cities

**Solution:** Server-based with ngrok
```bash
# Lead dev runs:
orb serve --public
# URL: https://team-orbiter.ngrok.io

# Everyone else:
orb config set-sync-path https://team-orbiter.ngrok.io
orb push
orb pull
```

### Example 3: Agency with Shared Network Drive

**Problem:** Office network, no cloud sync allowed

**Solution:** File-based with network drive
```bash
# On all office machines
orb config set-sync-path /Volumes/AgencyNAS/orbiter-sync
orb push
orb pull
```

## Under the Hood: What Actually Happens

### File-Based `orb push`:
```bash
rsync -a ~/comms/plans/spoq-web-apis/ ~/Dropbox/orbiter-sync/spoq-web-apis/
# Just file copying! No API calls.
```

### Server-Based `orb push`:
```bash
curl -X POST https://abc123.ngrok.io/push \
  -d '{"namespace": "spoq-web-apis", "files": {...}}'
# HTTP API call
```

## Summary

**"File-based Dropbox/Drive" means:**
- Orbiter copies files to a local folder
- That folder happens to be synced by Dropbox/Drive
- Orbiter doesn't use Dropbox/Drive APIs
- It's just file copying + background sync

**It's NOT:**
- Using Dropbox API
- Uploading directly to cloud
- Any kind of special integration

**It's literally just:**
```bash
cp ~/comms/plans/x ~/Dropbox/orbiter-sync/x
# Then Dropbox app syncs it (automatic, in background)
```

Simple!
