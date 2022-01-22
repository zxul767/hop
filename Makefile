NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
INFO_COLOR=\033[96;01m
WARN_COLOR=\033[33;01m

all: setup

reset: nuke
	make setup

setup: .setup

.setup:
	@echo "$(INFO_COLOR)==> Installing environment...$(NO_COLOR)"
	./install.sh
	@echo "$(OK_COLOR)DONE$(NO_COLOR)"

nuke:
	@echo "$(INFO_COLOR)==> Uninstalling environment...$(NO_COLOR)"
	./nuke.sh
	@echo "$(OK_COLOR)DONE$(NO_COLOR)"
