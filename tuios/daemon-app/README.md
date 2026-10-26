# TuiosDaemon.app: keep LAN access in TUIOS panes on macOS

A tiny app bundle that runs `tuios daemon`, so macOS Local Network Privacy has an app to attach the grant
to. Tracked upstream in [Gaurav-Gosain/tuios#1133](https://github.com/Gaurav-Gosain/tuios/issues/1133).

## The problem

On macOS 15 and later, a program needs permission to reach hosts on your local network, and the permission
belongs to an app (a signed app bundle), not to a bare command-line binary. A pane process is checked
against the app that launched it.

TUIOS panes are children of the background daemon. When the daemon is started from your terminal (Ghostty,
iTerm, ...) and that terminal later quits, the daemon is orphaned to `launchd` and has no app behind it.
From then on every non-Apple program in every pane fails to reach LAN addresses:

```
$ kubectl get nodes
Unable to connect to the server: dial tcp 192.168.1.221:6443: connect: no route to host
$ python3 -c "import socket;socket.create_connection(('192.168.1.221',6443),3)"
OSError: [Errno 65] No route to host
```

Apple-signed tools (`/usr/bin/nc`, `/usr/bin/curl`) and the internet keep working, which makes it look
random. The same thing happens with herdr, zellij and tmux:
[herdrdev/herdr#808](https://github.com/herdrdev/herdr/issues/808),
[zellij-org/zellij#5692](https://github.com/zellij-org/zellij/issues/5692),
[tmux/tmux#5735](https://github.com/tmux/tmux/issues/5735).

## The fix

Run the daemon through `TuiosDaemon.app`:

- `launcher.c`: a compiled launcher (a shell script cannot be signed) that `exec`s `tuios daemon` in place.
  It logs to `~/Library/Logs/tuios-daemon.log` and sets a full Homebrew `PATH`, because apps start with a
  minimal one. Arguments are passed on to tuios, so `--server lantest daemon` starts a test daemon.
- `Info.plist`: bundle ID `dev.local.tuios-daemon`, `LSUIElement` (no Dock icon) and the Local Network
  usage text.
- An ad-hoc signature (`codesign -s -`) gives the bundle the identity macOS needs.

macOS then asks once for Local Network access (and for folder access when a program touches Documents,
Desktop, ...). Allow it, and the grant covers every pane the daemon starts, whether or not the terminal that
launched it is still running.

Tested on macOS 27.0.1 with tuios 0.11.0 (Homebrew) and Ghostty 1.3.1: the daemon kept its PID and LAN access
after quitting and relaunching Ghostty.

## Install

Needs the Xcode command line tools (`cc`, `codesign`, `plutil`). Run from this folder in a terminal outside
TUIOS. `make` with no arguments prints the target list.

```sh
make install                # build and copy to ~/Applications
make lantest-start          # throwaway test daemon (--server lantest), your real sessions are untouched
make lantest-check HOST=192.168.1.221 PORT=6443   # LAN connect test in a pane of the test daemon
```

Click Allow when macOS asks for Local Network access. If no prompt appears, switch TuiosDaemon on in
System Settings > Privacy & Security > Local Network and run the check again. Then quit your terminal, open
it again, and run `make lantest-check` once more. It should still print `LAN-OK`. Stop the test daemon with
`make lantest-stop`.

To switch the real daemon over:

```sh
tuios kill-server           # sessions are saved and restored, but running processes end
make start                  # start the real daemon through the app
make autostart              # start the app at login
```

`make autostart` installs a LaunchAgent that runs at login and starts the app only when no daemon is
running, so it is safe to run while your daemon is up. Open your terminal after login finishes: if `tuios`
runs before the app and no daemon is running, `tuios` starts its own, and that one is owned by the terminal
again.

`make status` shows the app, autostart and the running daemon. `make uninstall` removes the app and the
login item. `make clean` deletes `build/`.

## Things to know

- **Do not rebuild or replace the app after granting.** The grant is tied to the signature, and replacing the
  app can silently void it. `make install` refuses to replace an installed app unless you pass `FORCE=1`.
- **Other privacy prompts need their usage text too.** Panes are attributed to the app, so the microphone
  (voice input in coding agents) only works if `Info.plist` has `NSMicrophoneUsageDescription`, which it does.
  For the camera or other protected resources add the matching `NS...UsageDescription` key and reinstall.
  Without the key macOS denies access silently and shows no prompt. After adding one, reinstall with
  `make install FORCE=1`, restart the daemon, and expect to grant Local Network again.
- **The environment is minimal.** A daemon started from an app does not see your shell's exported variables.
  Panes run zsh, which loads your rc files, so most of them come back. Check `PATH` and anything you set in
  `.zprofile` only.
- **Another tuios binary:** if tuios is not at `/opt/homebrew/bin/tuios`, build with
  `make install TUIOS_BIN=/path/to/tuios`.
- **Updating tuios** does not affect the app. It runs whatever is at `TUIOS_BIN` when it starts, so restart
  the daemon (`tuios kill-server`, then `make start`) to pick up a new version.
- **Stow:** `../.stow-local-ignore` keeps this folder out of your home directory when you run `stow tuios`.
- **The Local Network entry may stay** in System Settings after `make uninstall`. Remove it there if you
  want it gone.
