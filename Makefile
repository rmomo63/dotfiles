DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all:

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

mac_init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/mac.sh

init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh
