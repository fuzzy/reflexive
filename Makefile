VCMD=$$(which v)
VEXE=vunky

help:
	@echo "$(MAKE) [test|build]"
	@echo "$(MAKE) clean -- get rid of any binaries"
	@echo "$(MAKE) test -- supported"
	@echo "$(MAKE) build -- supported (requires test to pass)"
	@echo "$(MAKE) prod -- supported (does it all)"

test:
	@printf '\033[1;33m#####\033[0m TESTING\n'
	@printf "\033[1;36m$(VCMD) -stats test .\033[0m\n"
	@$(VCMD) -stats test .

build: clean
	@printf '\033[1;33m#####\033[0m BUILDING\n'
	@printf "\033[1;36m$(VCMD) -stats -o $(VEXE) .\033[0m\n"
	@$(VCMD) -stats -o $(VEXE) .

prod: clean
	@printf '\033[1;33m#####\033[0m BUILDING PROD\n'
	@printf "\033[1;36m$(VCMD) -stats -W -prod -o $(VEXE).prod .\033[0m\n"
	@$(VCMD) -stats -W -prod -o $(VEXE).prod .

clean:
	@printf '\033[1;33m#####\033[0m CLEANING\n'
	@printf "\033[1;36mrm -fv $(VEXE) $(VEXE).prod\033[0m\n"
	@rm -fv $(VEXE) $(VEXE).prod
