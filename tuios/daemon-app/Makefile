# TuiosDaemon.app: a tiny app bundle that runs `tuios daemon`, so macOS Local Network Privacy has an app
# to attach the grant to. Without it the daemon is orphaned to launchd once the terminal that started it
# quits, and every pane loses LAN access (EHOSTUNREACH). See https://github.com/Gaurav-Gosain/tuios/issues/1133
#
# Usage (run from a terminal OUTSIDE tuios):
#   make install            build and copy to ~/Applications (refuses to replace an existing app)
#   make lantest-start      start a throwaway daemon through the app (--server lantest)
#   make lantest-check HOST=192.168.1.221 PORT=6443
#   make start              start the real daemon through the app (stop the running one first)
#   make autostart          start the app at login
#   make status | uninstall | clean

TUIOS_BIN ?= /opt/homebrew/bin/tuios
PREFIX    ?= $(HOME)/Applications
HOST      ?=
PORT      ?= 22

NAME   := TuiosDaemon
LABEL  := dev.local.tuios-daemon
APP    := $(PREFIX)/$(NAME).app
BUILD  := build/$(NAME).app
AGENT  := $(HOME)/Library/LaunchAgents/$(LABEL).plist
PIDFILE := /tmp/tuios-$(shell id -u)/tuios.sock.pid
# A test daemon must not see the pane environment of the tuios we are running in.
CLEAN_ENV := env -u TUIOS_ENV -u TUIOS_PANE_ID -u TUIOS_WINDOW_ID -u TUIOS_SOCKET -u TUIOS_PANE_TOKEN -u TUIOS_SESSION

.DEFAULT_GOAL := help
.PHONY: help build install start lantest-start lantest-check lantest-stop autostart no-autostart status uninstall clean

help: ## show this help (default)
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-15s %s\n", $$1, $$2}'
	@echo
	@echo "  lantest-check needs HOST=<lan ip> [PORT=22]; override TUIOS_BIN and PREFIX if needed"

build: ## compile and sign the app into build/
	rm -rf $(BUILD)
	mkdir -p $(BUILD)/Contents/MacOS $(BUILD)/Contents/Resources
	cc -O2 -Wall -DTUIOS_BIN='"$(TUIOS_BIN)"' -o $(BUILD)/Contents/MacOS/$(NAME) launcher.c
	cp Info.plist $(BUILD)/Contents/Info.plist
	printf 'APPL????' > $(BUILD)/Contents/PkgInfo
	plutil -lint $(BUILD)/Contents/Info.plist
	codesign --force -s - $(BUILD)
	codesign --verify --verbose $(BUILD)

# The Local Network grant is bound to the signature, so replacing a granted app can void it.
install: build ## copy the app to ~/Applications (FORCE=1 replaces an existing one)
	@if [ -d "$(APP)" ] && [ "$(FORCE)" != "1" ]; then \
		echo "$(APP) already exists. Replacing it can void the Local Network grant."; \
		echo "Run 'make install FORCE=1' to replace it anyway."; \
		exit 1; \
	fi
	mkdir -p "$(PREFIX)"
	rm -rf "$(APP)"
	cp -R $(BUILD) "$(APP)"
	codesign --verify --verbose "$(APP)"
	@echo
	@echo "Installed $(APP)."
	@echo "Next: 'make lantest-start', then 'make lantest-check HOST=<lan ip> PORT=<port>' and click Allow when"
	@echo "macOS asks for Local Network access (or turn TuiosDaemon on in System Settings > Privacy & Security >"
	@echo "Local Network)."

start: ## start the real daemon through the app (stop a running one first)
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "A tuios daemon is already running (pid $$(cat $(PIDFILE)))."; \
		echo "Stop it first with 'tuios kill-server', from a terminal outside tuios. Sessions are saved and restored."; \
		exit 1; \
	fi
	open -a "$(APP)"

lantest-start: ## start a throwaway test daemon (--server lantest) through the app
	open -n -a "$(APP)" --args --server lantest daemon --no-restore
	@sleep 2
	$(CLEAN_ENV) $(TUIOS_BIN) --server lantest list-sessions

lantest-check: ## run a LAN connect test in a pane of the test daemon
	@[ -n "$(HOST)" ] || { echo "usage: make lantest-check HOST=<lan ip> [PORT=22]"; exit 1; }
	-$(CLEAN_ENV) $(TUIOS_BIN) --server lantest new lt --detach >/dev/null 2>&1
	@sleep 2
	$(CLEAN_ENV) $(TUIOS_BIN) --server lantest send-text -s lt -w 0 "python3 -c \"import socket;s=socket.socket();s.settimeout(3);s.connect(('$(HOST)',$(PORT)));print('LAN-OK')\" 2>&1 | tail -1"
	$(CLEAN_ENV) $(TUIOS_BIN) --server lantest send-keys -s lt -w 0 Enter
	@sleep 4
	@$(CLEAN_ENV) $(TUIOS_BIN) --server lantest capture-pane -s lt -w 0 | grep -E "LAN-OK|Errno|Error" | tail -2 || echo "no result captured"

lantest-stop: ## stop the test daemon
	-$(CLEAN_ENV) $(TUIOS_BIN) --server lantest kill-server

autostart: ## start the app at login (LaunchAgent)
	mkdir -p "$(HOME)/Library/LaunchAgents"
	printf '%s\n' \
		'<?xml version="1.0" encoding="UTF-8"?>' \
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
		'<plist version="1.0"><dict>' \
		'<key>Label</key><string>$(LABEL)</string>' \
		'<key>ProgramArguments</key><array><string>/usr/bin/open</string><string>-a</string><string>$(APP)</string></array>' \
		'<key>RunAtLoad</key><true/>' \
		'</dict></plist>' > "$(AGENT)"
	plutil -lint "$(AGENT)"
	-launchctl bootout gui/$$(id -u)/$(LABEL) 2>/dev/null
	launchctl bootstrap gui/$$(id -u) "$(AGENT)"
	@echo "$(NAME) will start at login. Start it before the first 'tuios', or tuios starts its own daemon."

no-autostart: ## remove the login LaunchAgent
	-launchctl bootout gui/$$(id -u)/$(LABEL) 2>/dev/null
	rm -f "$(AGENT)"

status: ## show the app, autostart and running daemon
	@echo "app:    $$([ -d "$(APP)" ] && echo "$(APP)" || echo 'not installed')"
	@[ -d "$(APP)" ] && codesign -dv "$(APP)" 2>&1 | grep -E "Identifier|Signature" || true
	@echo "login:  $$([ -f "$(AGENT)" ] && echo 'autostart on' || echo 'autostart off')"
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "daemon:"; ps -o pid,ppid,lstart,command -p $$(cat "$(PIDFILE)"); \
	else echo "daemon: not running"; fi

uninstall: no-autostart ## remove the app and the login LaunchAgent
	rm -rf "$(APP)"
	@echo "Removed $(APP). Its Local Network entry may remain in System Settings."

clean: ## delete build/
	rm -rf build
