#!/usr/bin/env bash
# uncomment for debugging
# set -x
set -e

# to make script work from any directory
# change to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# running stow for each directory in the stow directory
for dir in "$SCRIPT_DIR/stow"/*; do
    if [ -d "$dir" ]; then
        echo "Running command: stow -v -d \"$SCRIPT_DIR/stow\" -t \"${HOME}\" \"$(basename "$dir")\""
        stow -v -d "$SCRIPT_DIR/stow" -t "${HOME}" "$(basename "$dir")"
    fi
done
