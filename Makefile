##
# MPV Redirector
#
# @file
# @version 0.1

SCRIPT := mpv-redirector.sh
LAUNCHER_FILE := mpv-redirector.desktop
LAUNCHER_DIR := ~/.local/share/applications
PREFIX ?= ~/.local

show:
	echo $(SCRIPT)
	echo $(LAUNCHER_FILE)
	echo $(LAUNCHER_DIR)
	echo $(PREFIX)/bin

install:
	mkdir -p $(PREFIX)/bin
	mkdir -p $(LAUNCHER_DIR)
	cp $(LAUNCHER_FILE) $(LAUNCHER_DIR)/
	cp $(SCRIPT) $(PREFIX)/bin

uninstall:
	rm $(LAUNCHER_DIR)/$(LAUNCHER_FILE)
	rm $(PREFIX)/bin/$(SCRIPT)

# end
