#!/bin/bash

# echo "NAMESPACE: $NAMESPACE"
# echo "NAME: $NAME"
# exit 0

# Check if gum is installed
if ! command -v gum &> /dev/null; then
  echo "Error: Gum is not installed."
  echo "To install Gum, run one of the following commands:"
  echo "  brew install gum    # macOS"
  echo "  sudo apt install gum # Ubuntu/Debian"
  echo "  sudo dnf install gum # Fedora/RHEL"
  echo "  sudo pacman -S gum   # Arch"
  echo "  curl -s https://gum.io/install | bash # Direct from GitHub"
  # press any key to exit
  read -n 1 -s -r -p "Press any key to exit..."
  exit 0
fi

# Prompt for the `-s` time too look back argument using gum
RANGE=$(gum input --placeholder "Enter Time to look back [Return logs newer than a relative duration like 5s, 2m, or 3h. (default 48h0m0s)]:")
# search string
SEARCH_STRING=$(gum input --placeholder "Enter search string [ --include ]:")

echo $RANGE

# emit clear screen command
clear
tmux clear-history || true

# Build stern arguments array
stern_args=(
  "$NAME"
  "-n"
  "$NAMESPACE"
  "--diff-container"
)

# Add selector if search string is provided
if [[ -n "$SEARCH_STRING" ]]; then
  stern_args+=("--include" "$SEARCH_STRING")
fi

# Add time range if provided
if [[ -n "$RANGE" ]]; then
  stern_args+=("--since" "$RANGE")
fi

# Run stern command with all arguments
echo "Running stern command: stern ${stern_args[*]}"
stern "${stern_args[@]}"
