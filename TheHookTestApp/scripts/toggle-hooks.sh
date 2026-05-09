
#!/bin/bash

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        🔧 Pre-Push Hook Toggle"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# --- Find repo root ---
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
    echo "❌ Error: Not inside a git repository."
    exit 1
fi

HOOKS_DIR="$REPO_ROOT/.git/hooks"
SCRIPTS_DIR="$REPO_ROOT/scripts"

ACTIVE_HOOK="$HOOKS_DIR/pre-push"
DISABLED_HOOK="$HOOKS_DIR/pre-push.disabled"

# --- STATUS ---
show_status() {
    echo "📊 Current Hook Status:"
    echo ""
    if [ -f "$ACTIVE_HOOK" ] && [ -x "$ACTIVE_HOOK" ]; then
        echo "   🟢 pre-push hook is: ENABLED"
        echo "      The hook will run on every git push."
    elif [ -f "$DISABLED_HOOK" ]; then
        echo "   🔴 pre-push hook is: DISABLED"
        echo "      Your pushes will go through without analysis."
        echo "      Run 'bash scripts/toggle-hooks.sh enable' to turn it back on."
    else
        echo "   ⚪ pre-push hook is: NOT INSTALLED"
        echo "      Run 'bash scripts/install-hooks.sh' to install it."
    fi
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# --- ENABLE ---
enable_hook() {
    echo "▶️  Enabling pre-push hook..."
    echo ""

    # Already enabled
    if [ -f "$ACTIVE_HOOK" ] && [ -x "$ACTIVE_HOOK" ]; then
        echo "   ✅ Hook is already enabled. Nothing to do."
        show_status
        exit 0
    fi

    # Was disabled — restore it
    if [ -f "$DISABLED_HOOK" ]; then
        mv "$DISABLED_HOOK" "$ACTIVE_HOOK"
        chmod +x "$ACTIVE_HOOK"
        echo "   ✅ Hook restored and enabled."
        show_status
        exit 0
    fi

    # Not installed at all — install fresh from scripts/
    if [ -f "$SCRIPTS_DIR/pre-push" ]; then
        cp "$SCRIPTS_DIR/pre-push" "$ACTIVE_HOOK"
        chmod +x "$ACTIVE_HOOK"
        echo "   ✅ Hook installed fresh and enabled."
        show_status
        exit 0
    fi

    echo "   ❌ Could not find scripts/pre-push to install."
    echo "      Make sure you have pulled the latest develop branch."
    echo ""
    exit 1
}

# --- DISABLE ---
disable_hook() {
    echo "⏸️  Disabling pre-push hook..."
    echo ""

    # Already disabled
    if [ -f "$DISABLED_HOOK" ]; then
        echo "   🔴 Hook is already disabled. Nothing to do."
        show_status
        exit 0
    fi

    # Active — disable it by renaming
    if [ -f "$ACTIVE_HOOK" ]; then
        mv "$ACTIVE_HOOK" "$DISABLED_HOOK"
        echo "   🔴 Hook disabled."
        echo "      Your pushes will go through without analysis."
        echo "      The hook is saved — run enable to restore it instantly."
        show_status
        exit 0
    fi

    # Not installed
    echo "   ⚪ Hook is not installed. Nothing to disable."
    show_status
    exit 0
}

# --- MAIN ---
case "$1" in
    enable)
        enable_hook
        ;;
    disable)
        disable_hook
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: bash scripts/toggle-hooks.sh [command]"
        echo ""
        echo "Commands:"
        echo "   enable   → Activates the pre-push hook"
        echo "   disable  → Deactivates the hook (hook is saved, not deleted)"
        echo "   status   → Shows whether the hook is currently on or off"
        echo ""
        echo "Examples:"
        echo "   bash scripts/toggle-hooks.sh enable"
        echo "   bash scripts/toggle-hooks.sh disable"
        echo "   bash scripts/toggle-hooks.sh status"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        exit 1
        ;;
esac
