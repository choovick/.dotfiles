# .dotfiles

## Requirements

1. GNU Stow

OSX install: `brew install stow`

## Usage

1. Clone repo to home directory if not already present

    ```bash
    git@github.com:choovick/.dotfiles.git $HOME/.dotfiles
    ```

1. Change to repo directory

    ```bash
    cd $HOME/.dotfiles
    ```

1. Run stow command against stow directory for all subdirectories

    ```bash
    stow -d stow -t $HOME $(ls -d stow/*/| xargs -n 1 basename)
    ```

    or using helper script

    ```bash
    ./stow.sh
    ```
