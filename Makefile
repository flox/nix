makefiles = \
  mk/precompiled-headers.mk \
  local.mk \
  src/libutil/local.mk \
  src/libstore/local.mk \
  src/libfetchers/local.mk \
  src/libmain/local.mk \
  src/libexpr/local.mk \
  src/libcmd/local.mk \
  src/nix/local.mk \
  src/nix-instantiate/local.mk \
  src/resolve-system-dependencies/local.mk \
  scripts/local.mk \
  misc/bash/local.mk \
  misc/fish/local.mk \
  misc/zsh/local.mk \
  misc/systemd/local.mk \
  misc/launchd/local.mk \
  misc/upstart/local.mk \
  doc/manual/local.mk \
  doc/internal-api/local.mk

-include Makefile.config

ifeq ($(tests), yes)
makefiles += \
  src/libutil/tests/local.mk \
  src/libstore/tests/local.mk \
  src/libexpr/tests/local.mk \
  tests/local.mk \
  tests/plugins/local.mk
else
makefiles += \
  mk/disable-tests.mk
endif

OPTIMIZE = 1

ifeq ($(OPTIMIZE), 1)
  GLOBAL_CXXFLAGS += -O3 $(CXXLTO)
  GLOBAL_LDFLAGS += $(CXXLTO)
else
  GLOBAL_CXXFLAGS += -O0 -U_FORTIFY_SOURCE
endif

include mk/lib.mk

GLOBAL_CXXFLAGS += -g -Wall -include config.h -std=c++2a -I src \
	-isystem /nix/store/9x6jfl84234im3f4gsrl1js3zyqz76jd-nlohmann_json-3.11.2/include \
		# -isystem /nix/store/hl5lsmyf6alwj91nv8kmg2iz1lbnxym9-curl-7.86.0-dev/include \
		# -isystem /nix/store/hyxa8plwvgbj16fi2rlvm2sy6idlkab1-libsodium-1.0.18-dev/include \
		# -isystem /nix/store/ppqyr8qzdswkswcyb7214y9qg8cr7dnn-sqlite-3.39.4-dev/include \
		# -isystem /nix/store/6015i0n0wxgqyg5ranqkdv9rbhyyqb4g-lowdown-0.9.0-dev/include \
		# -isystem /nix/store/68pwg680mq51rlw5bkpii4hbbabzwl2b-editline-1.17.1-dev/include \
		# -isystem /nix/store/f95kxwhnr2bazy7nl6wzwjiak02dlp9v-openssl-3.0.7-dev/include \
		# -isystem /nix/store/vvfcnmqni2ijgzs9pcb3szx0axdmvjda-libarchive-3.6.1-dev/include \
		# -isystem /nix/store/75j80ikwsw1qkb4171kspshqyc239p2h-brotli-1.0.9-dev/include \
		-sUSE_BOOST_HEADERS=1 \
		-sUSE_SQLITE3=1
