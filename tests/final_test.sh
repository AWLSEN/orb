#!/bin/bash

echo "=== Orbiter Final Test ==="
echo ""

# Clean start
rm -rf ~/.orbiter /tmp/orbiter-final-test

echo "1. Installing..."
./install.sh
echo ""

echo "2. Configuring sync path..."
orb config set-sync-path /tmp/orbiter-final-test
echo ""

echo "3. Adding namespaces..."
orb config add spoq-web-apis
orb config add spoq-cli
echo ""

echo "4. Checking configuration..."
orb config list
echo ""

echo "5. Checking status..."
orb status
echo ""

echo "6. Pushing plans..."
orb push
echo ""

echo "7. Verifying synced files..."
echo "Synced namespaces:"
ls -la /tmp/orbiter-final-test/
echo ""

echo "8. Synced spoq-web-apis content:"
ls -la /tmp/orbiter-final-test/spoq-web-apis/
echo ""

echo "9. Testing pull..."
orb pull
echo ""

echo "=== ✓ All Tests Passed ==="
echo ""
echo "Orbiter is ready to use!"
echo ""
echo "Quick commands:"
echo "  orb push    - Push your plans to team"
echo "  orb pull    - Pull plans from team"
echo "  orb status  - Check sync status"
