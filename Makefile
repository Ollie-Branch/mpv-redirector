##
# MPV Redirector
#
# @file
# @version 0.1

SCRIPT := mpv-redirector.sh
LAUNCHER_FILE := mpv-redirector.desktop
LAUNCHER_DIR := ~/.local/share/applications
PREFIX ?= ~/.local
EXP_PREFIX = $(shell echo $(PREFIX))

show:
	echo $(SCRIPT)
	echo $(LAUNCHER_FILE)
	echo $(LAUNCHER_DIR)
	echo $(PREFIX)/bin

install:
	mkdir -p $(PREFIX)/bin
	mkdir -p $(LAUNCHER_DIR)
	cp $(SCRIPT) $(PREFIX)/bin
# this is necessary because the >> operator in the sed command will just append
# file contents otherwise
	if [ -f $(LAUNCHER_DIR)/$(LAUNCHER_FILE) ] ; then \
		rm $(LAUNCHER_DIR)/$(LAUNCHER_FILE) ; \
	fi
# Why don't .desktop files use path or expand vars?
	sed 's|EXEC|Exec=/usr/bin/env XDG_CONFIG_HOME=$(XDG_CONFIG_HOME) $(EXP_PREFIX)/bin/$(SCRIPT) %u|g' $(LAUNCHER_FILE) \
		>> $(LAUNCHER_DIR)/$(LAUNCHER_FILE)
	update-desktop-database $(LAUNCHER_DIR)

uninstall:
	rm $(LAUNCHER_DIR)/$(LAUNCHER_FILE)
	rm $(PREFIX)/bin/$(SCRIPT)
	update-desktop-database $(LAUNCHER_DIR)

# end
