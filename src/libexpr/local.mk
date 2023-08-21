programs += libexpr.html
# libraries += libexpr.html

# libexpr.html_NAME = libnixexpr

libexpr.html_DIR := $(d)

libexpr.html_SOURCES := \
  $(wildcard $(d)/*.cc) \
  $(wildcard $(d)/value/*.cc) \
  $(wildcard $(d)/primops/*.cc) \
  $(wildcard $(d)/flake/*.cc) \
  $(d)/lexer-tab.cc \
  $(d)/parser-tab.cc

libexpr.html_CXXFLAGS += -I src/libutil -I src/libstore -I src/libfetchers -I src/libmain -I src/libexpr -isystem /nix/store/1zdkiln33in1z3dpszjjka172xa1x33q-emscripten-openssl-3.0.9-dev/include

libexpr.html_LIBS = libutil libstore libfetchers /nix/store/0xa20qx51sr70c92sj1hlcb1ya2pxjqm-emscripten-openssl-3.0.9/lib/libcrypto.a

libexpr.html_LDFLAGS += \
			  -sUSE_SQLITE3=1 \
			  -sUSE_BOOST_HEADERS=1 \
			  -sEXPORTED_RUNTIME_METHODS=ccall,cwrap \
			  -sEXPORTED_FUNCTIONS=_evalFiler

	 # -sERROR_ON_UNDEFINED_SYMBOLS=0
	 # -s USE_PTHREADS=1
	 # -pthread \

ifdef HOST_LINUX
 libexpr.html_LDFLAGS += -ldl -L/nix/store/0xa20qx51sr70c92sj1hlcb1ya2pxjqm-emscripten-openssl-3.0.9/lib -lcrypto
endif

# The dependency on libgc must be propagated (i.e. meaning that
# programs/libraries that use libexpr must explicitly pass -lgc),
# because inline functions in libexpr's header files call libgc.
libexpr.html_LDFLAGS_PROPAGATED = $(BDW_GC_LIBS)

# libexpr.html_ORDER_AFTER := $(d)/parser-tab.cc $(d)/parser-tab.hh $(d)/lexer-tab.cc $(d)/lexer-tab.hh

$(d)/parser-tab.cc $(d)/parser-tab.hh: $(d)/parser.y
	$(trace-gen) bison -v -o $(libexpr_DIR)/parser-tab.cc $< -d

$(d)/lexer-tab.cc $(d)/lexer-tab.hh: $(d)/lexer.l
	$(trace-gen) flex --outfile $(libexpr_DIR)/lexer-tab.cc --header-file=$(libexpr_DIR)/lexer-tab.hh $<

clean-files += $(d)/parser-tab.cc $(d)/parser-tab.hh $(d)/lexer-tab.cc $(d)/lexer-tab.hh

$(eval $(call install-file-in, $(d)/nix-expr.pc, $(libdir)/pkgconfig, 0644))

$(foreach i, $(wildcard src/libexpr/value/*.hh), \
  $(eval $(call install-file-in, $(i), $(includedir)/nix/value, 0644)))
$(foreach i, $(wildcard src/libexpr/flake/*.hh), \
  $(eval $(call install-file-in, $(i), $(includedir)/nix/flake, 0644)))

$(d)/primops.cc: $(d)/imported-drv-to-derivation.nix.gen.hh $(d)/primops/derivation.nix.gen.hh $(d)/fetchurl.nix.gen.hh

$(d)/flake/flake.cc: $(d)/flake/call-flake.nix.gen.hh

src/libexpr/primops/fromTOML.o:	ERROR_SWITCH_ENUM =
