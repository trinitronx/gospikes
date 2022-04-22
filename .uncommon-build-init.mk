ifeq (,$(wildcard .uncommon-build))
  $(shell echo "\033[44m🔍\033[0m \033[0;36m... Looking for .uncommon-build ... \033[0m" >&2;    \
    echo "\033[0;31m.uncommon-build is curiously missing... 🧐 installing submodule\033[0m" >&2; \
    git submodule add https://github.com/LyraPhase/uncommon-build.git .uncommon-build >&2;       \
    echo "\033[0;31mCommitting '.uncommon-build' and '.gitmodules'\033[0m" >&2;                  \
    git add .uncommon-build .gitmodules &&                                                       \
    git commit -m 'Installing .uncommon-build as a submodule'                                    \
  )
else
  # Ensure `.uncommon-build` is updated and committed in .gitmodules
  $(shell echo "\033[0;31mUpdating '.uncommon-build' and '.gitmodules'\033[0m" >&2 )
  $(shell git submodule update --init .uncommon-build >&2 )
endif

stylish: ## no-help
	@[ -d .uncommon-build ] && echo '\033[47m🤵‍♂️\033[0m \033[1;92m.uncommon-build is now installed!\033[0m' \
		|| echo '\033[41m🤦\033[0m \033[1;91m .uncommon-build installation had issues!\033[0m'
	@echo '\033[44m🔍\033[0m \033[0;36m... Looking for single-colon clean target in Makefile ... \033[0m' >&2
	$(shell if !grep -q 'clean::' Makefile;                                                                       \
		then sed -i '' -e 's/^clean:\([^:]*.*\)/clean::\1/' Makefile;                                         \
	        git add Makefile;                                                                                     \
		git commit -m 'uncommon-build install: Convert single-colon clean: to double-colon clean:: rule' ; fi )

include .uncommon-build/main.mk
