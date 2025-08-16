# .dotfiles

## Requirements

1. GNU Stow

OSX install: `brew install stow`

## Usage

1. Clone repo to home directory if not already present

    ```bash
    git clone git@github.com:choovick/.dotfiles.git $HOME/.dotfiles
    ```

1. Change to repo directory

    ```bash
    cd $HOME/.dotfiles
    ```

1. Stow all package directories

    ```bash
    stow */
    ```

    Or stow individual packages:

    ```bash
    stow nvim
    stow zsh
    stow tmux
    # etc.
    ```
