#!/bin/bash
# Quick test of orbiter functionality

set -euo pipefail

echo "=== Orbiter Test ==="
echo ""

# Test help
echo "1. Testing help command..."
./orb help | head -3
echo ""

# Test version
echo "2. Testing version command..."
./orb version
echo ""

# Test config
echo "3. Testing config..."
./orb config set-sync-path /tmp/orbiter-test-sync
./orb config list
echo ""

# Test status
echo "4. Testing status..."
./orb status
echo ""

echo "✓ Basic tests passed!"
echo ""
echo "To test with real namespaces:"
echo "  ./orb config add spoq-web-apis"
echo "  ./orb push"
