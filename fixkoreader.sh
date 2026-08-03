#!/bin/sh
# Name: Fix KOReader
# Author: fixkoreader.sh contributors
#
# fixkoreader.sh - relocate a misplaced KOReader install back to /mnt/us/koreader
#
# Symptom this fixes: KOReader got unzipped somewhere under
# /mnt/us/documents (browser download, mis-extracted zip, etc.) instead of
# /mnt/us/koreader, so KUAL never finds it.
#
# Safe by design: if /mnt/us/koreader already exists, this does nothing.
#
# Run via KUAL's SH_Integration - drop this file in /mnt/us/documents and
# it appears in the Kindle library as a book titled "Fix KOReader" (from
# the Name: header above). Tap it to run; SH_Integration pipes stdout to
# the screen via FBInk automatically.

TARGET="/mnt/us/koreader"
SEARCH_ROOT="/mnt/us/documents"

echo "=== Fix KOReader ==="
echo

if [ -e "$TARGET" ]; then
    echo "Found $TARGET already - nothing to do."
    echo "(If KOReader still isn't showing in KUAL, the problem is elsewhere.)"
    exit 0
fi

echo "Looking for koreader under $SEARCH_ROOT ..."
echo

# A real KOReader install has koreader.sh at its root - use that as the
# marker so a random folder someone happens to have named "koreader"
# doesn't get grabbed by mistake.
MARKERS=$(find "$SEARCH_ROOT" -type f -name "koreader.sh" 2>/dev/null)
COUNT=$(printf '%s\n' "$MARKERS" | grep -c .)

if [ "$COUNT" -eq 0 ]; then
    echo "No koreader.sh found anywhere under $SEARCH_ROOT."
    echo "Nothing to move. Is KOReader actually unzipped there?"
    exit 1
fi

if [ "$COUNT" -gt 1 ]; then
    echo "Found more than one koreader.sh - using the first one:"
    printf '%s\n' "$MARKERS"
    echo
fi

MARKER=$(printf '%s\n' "$MARKERS" | head -n 1)
FOUND_DIR=$(dirname "$MARKER")

echo "Found KOReader install at:"
echo "  $FOUND_DIR"
echo
echo "Moving it to:"
echo "  $TARGET"
echo

if mv "$FOUND_DIR" "$TARGET"; then
    echo "Done. Go to KUAL and launch KOReader."
else
    echo "Move failed. Check permissions / free space and try again."
    exit 1
fi
