let
  pkgs = import <nixpkgs> { };
  elmPkgs = pkgs.elmPackages;
  elm-start = pkgs.writeShellScriptBin "elm-start" ''
      elm-live src/Main.elm --start-page=index.html -v --hot --pushstate -- --output=elm.js
      '';
in
pkgs.mkShell {
  buildInputs = [
    elmPkgs.elm
    elmPkgs.elm-language-server
    elmPkgs.elm-live
    elm-start
    ];
}
