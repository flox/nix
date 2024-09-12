# nix-instantiate (emscripten WASM build)

    git clone https://github.com/flox/nix/tree/wasm
    cd nix
    nix build .#d.nix -L

This will create a results folder where you can start a webserver in:

    python3 -m http.server

This creates a port on localhost:8000 which can be opened in the webbrowser:

    localhost:8000

Inside this webbrowser press `F12` for the `javascript console` and then evaluate this code:

    try {Module.ccall("main_nix_instantiate2","string",["string"],["let\n c = 2; in { inherit c; c = 2;}"]);} catch (e) { console.log(getExceptionMessage(e).toString()); };

    try {Module.ccall("main_nix_instantiate2","string",["string"],["let c = 2; in { inherit c;}"]);} catch (e) { console.log(getExceptionMessage(e).toString()); };

    try {Module.ccall("main_nix_instantiate2","string",["string"],["let\n c = 2; in { inherit c; f = builtins.readDir ./.;}"]);} catch (e) { console.log(getExceptionMessage(e).toString()); };

