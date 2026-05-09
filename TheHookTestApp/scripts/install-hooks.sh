#!/bin/bash

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        🔧 Pre-Push Hook Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# --- STEP 1: Find repo root ---
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
    echo "❌ Error: Not inside a git repository."
    echo "   Make sure you are inside the project folder."
    echo ""
    exit 1
fi

HOOKS_DIR="$REPO_ROOT/.git/hooks"
SCRIPTS_DIR="$REPO_ROOT/scripts"

# --- STEP 2: Fix permissions on all scripts ---
echo "🔑 Setting permissions..."
chmod +x "$SCRIPTS_DIR/pre-push"
chmod +x "$SCRIPTS_DIR/install-hooks.sh"
chmod +x "$SCRIPTS_DIR/toggle-hooks.sh"
echo "   ✅ Done"
echo ""

# --- STEP 3: Check Xcode is installed (Xcode 26 compatible) ---
echo "🔍 Checking Xcode installation..."
if ! xcrun --find xcodebuild &>/dev/null; then
    echo ""
    echo "   ❌ Xcode not found."
    echo "   Please install Xcode from the App Store and try again."
    echo ""
    exit 1
fi

# Also verify xcodebuild actually runs
if ! xcrun xcodebuild -version &>/dev/null; then
    echo ""
    echo "   ❌ Xcode found but xcodebuild is not responding."
    echo "   Try running: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
    echo "   Then run this installer again."
    echo ""
    exit 1
fi

XCODE_VERSION=$(xcrun xcodebuild -version 2>/dev/null | head -1)
echo "   ✅ Found: $XCODE_VERSION"
echo ""

# --- STEP 4: Check xcode-select is pointing to full Xcode ---
echo "🔎 Checking xcode-select path..."
XCODE_PATH=$(xcode-select -p 2>/dev/null)
if [[ "$XCODE_PATH" == *"CommandLineTools"* ]]; then
    echo ""
    echo "   ⚠️  xcode-select is pointing to CommandLineTools, not full Xcode."
    echo "   Fixing automatically..."
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
    if [ $? -ne 0 ]; then
        echo ""
        echo "   ❌ Could not fix automatically. Please run manually:"
        echo "   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
        echo ""
        exit 1
    fi
    echo "   ✅ Fixed: now pointing to Xcode.app"
else
    echo "   ✅ Pointing to: $XCODE_PATH"
fi
echo ""

# --- STEP 5: Check pre-push source file exists ---
echo "📄 Checking hook source file..."
if [ ! -f "$SCRIPTS_DIR/pre-push" ]; then
    echo ""
    echo "   ❌ scripts/pre-push not found."
    echo "   Make sure you have pulled the latest develop branch."
    echo ""
    exit 1
fi
echo "   ✅ Found scripts/pre-push"
echo ""

# --- STEP 6: Backup existing hook if present ---
echo "💾 Checking for existing hook..."
if [ -f "$HOOKS_DIR/pre-push" ]; then
    cp "$HOOKS_DIR/pre-push" "$HOOKS_DIR/pre-push.backup"
    echo "   ✅ Existing hook backed up to .git/hooks/pre-push.backup"
else
    echo "   ✅ No existing hook found. Clean install."
fi
echo ""

# --- STEP 7: Install the hook ---
echo "📦 Installing pre-push hook..."
cp "$SCRIPTS_DIR/pre-push" "$HOOKS_DIR/pre-push"
chmod +x "$HOOKS_DIR/pre-push"
echo "   ✅ Installed to .git/hooks/pre-push"
echo ""

# --- STEP 8: Auto detect project name ---
echo "🔎 Detecting project name..."
PROJECT_NAME=$(find "$REPO_ROOT" -maxdepth 2 -name "*.xcodeproj" \
    | head -1 \
    | xargs basename 2>/dev/null \
    | sed 's/\.xcodeproj//')
if [ -z "$PROJECT_NAME" ]; then
    echo "   ⚠️  Could not auto-detect project name."
    echo "   Make sure a .xcodeproj file exists in the repo root."
else
    echo "   ✅ Detected project: $PROJECT_NAME"
fi
echo ""

# --- STEP 9: Verify hook is active ---
echo "✔️  Verifying installation..."
if [ -f "$HOOKS_DIR/pre-push" ] && [ -x "$HOOKS_DIR/pre-push" ]; then
    echo "   ✅ Hook is active and executable"
else
    echo "   ❌ Something went wrong. Hook not found at .git/hooks/pre-push"
    exit 1
fi
echo ""

# --- DONE ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Pre-push hook installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 What the hook does on every git push:"
echo "   1️⃣  Finds Swift files you changed vs develop"
echo "   2️⃣  Uses compiler index to find impacted tests"
echo "   3️⃣  Shows exact xcodebuild command to run"
echo "   4️⃣  Calculates delta coverage % for changed lines"
echo ""
echo "⚠️  IMPORTANT — One time setup before your first push:"
echo "   Open Xcode and build the project once → Cmd + B"
echo "   This generates the compiler index the hook needs."
echo ""
echo "🔧 Manage the hook anytime:"
echo "   bash scripts/toggle-hooks.sh status   → check on/off"
echo "   bash scripts/toggle-hooks.sh disable  → turn off"
echo "   bash scripts/toggle-hooks.sh enable   → turn back on"
echo ""
echo "🚨 Emergency push (skip hook entirely):"
echo "   git push --no-verify"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
