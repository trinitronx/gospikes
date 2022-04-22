ifeq (,$(wildcard .uncommon-build))
  $(shell                                                                                        \
    echo "\033[0;31m.uncommon-build is curiously missing... 🧐 installing submodule\033[0m" >&2; \
    git submodule add https://github.com/LyraPhase/uncommon-build.git .uncommon-build >&2;       \
    echo "\033[0;31mCommitting '.uncommon-build' and '.gitmodules'\033[0m" >&2                   \
    git add .uncommon-build .gitmodules                                                          \
    git commit -m 'Installing .uncommon-build as a submodule'                                    \
  )
else
  # Ensure `.uncommon-build` is updated and committed in .gitmodules
  $(shell git submodule update --init .uncommon-build >&2 )
  $(shell echo "\033[0;31mUpdating '.uncommon-build' and '.gitmodules'\033[0m" >&2
endif

include .uncommon-build/main.mk
