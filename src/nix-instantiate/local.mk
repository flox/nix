programs += nix-instantiate.html

nix-instantiate.html_DIR := $(d)

nix-instantiate.html_SOURCES := \
  $(wildcard src/nix-instantiate/*.cc) \
  $(wildcard $(d)/*.cc) \
  $(wildcard src/libexpr/*.cc) \
  $(wildcard src/libexpr/value/*.cc) \
  $(wildcard src/libexpr/flake/*.cc) \
  $(wildcard src/libexpr/primops/*.cc) \
  src/libexpr/lexer-tab.cc \
  src/libexpr/parser-tab.cc

  # $(wildcard $(d)/*.cc) \
  # $(wildcard src/nix-build/*.cc) \
  # $(wildcard src/nix-channel/*.cc) \
  # $(wildcard src/nix-collect-garbage/*.cc) \
  # $(wildcard src/nix-copy-closure/*.cc) \
  # $(wildcard src/nix-daemon/*.cc) \
  # $(wildcard src/nix-env/*.cc) \
  # $(wildcard src/nix-store/*.cc) \
  # $(wildcard src/build-remote/*.cc) \

nix-instantiate.html_CXXFLAGS += -I src/libutil -I src/libstore -I src/libfetchers -I src/libexpr -I src/libmain -I src/libcmd

nix-instantiate.html_LIBS = libexpr libmain libfetchers libstore libutil libcmd

# export EM_PORTS=${PWD}/ports
# export EM_CACHE=${PWD}/cache
	# -L/nix/store/0xa20qx51sr70c92sj1hlcb1ya2pxjqm-emscripten-openssl-3.0.9/lib -lcrypto
	  # $(shell pkg-config --libs openssl)
nix-instantiate.html_LDFLAGS = \
	  $(shell echo "$(NIX_LDFLAGS)" | cut -f 5- -d' ') \
	  -lcrypto \
	  -sNO_EXIT_RUNTIME=1 \
	  -sALLOW_MEMORY_GROWTH=1 \
	  -sEXPORTED_RUNTIME_METHODS=cwrap,ccall,UTF8ToString,ptrToString,allocateUTF8,UTF32ToString \
	  -sEXPORTED_FUNCTIONS=_processExpr,_main_nix_instantiate2 \
	  -sEXPORT_EXCEPTION_HANDLING_HELPERS

src/libexpr/parser-tab.cc src/libexpr/parser-tab.hh: src/libexpr/parser.y
	$(trace-gen) bison -v -o src/libexpr/parser-tab.cc $< -d

src/libexpr/lexer-tab.cc src/libexpr/lexer-tab.hh: src/libexpr/lexer.l
	$(trace-gen) flex --outfile src/libexpr/lexer-tab.cc --header-file=src/libexpr/lexer-tab.hh $<

clean-files += $(d)/parser-tab.cc $(d)/parser-tab.hh $(d)/lexer-tab.cc $(d)/lexer-tab.hh


$(foreach name, \
  nix-build nix-channel nix-collect-garbage nix-copy-closure nix-daemon nix-env nix-hash nix-instantiate nix-prefetch-url nix-shell nix-store, \
  $(eval $(call install-symlink, nix, $(bindir)/$(name))))
$(eval $(call install-symlink, $(bindir)/nix, $(libexecdir)/nix/build-remote))

src/nix-env/user-env.cc: src/nix-env/buildenv.nix.gen.hh

src/nix/develop.cc: src/nix/get-env.sh.gen.hh

src/nix-channel/nix-channel.cc: src/nix-channel/unpack-channel.nix.gen.hh

src/nix/main.cc: doc/manual/generate-manpage.nix.gen.hh doc/manual/utils.nix.gen.hh

src/nix/doc/files/%.md: doc/manual/src/command-ref/files/%.md
	@mkdir -p $$(dirname $@)
	@cp $< $@

src/nix/profile.cc: src/nix/profile.md src/nix/doc/files/profiles.md.gen.hh
