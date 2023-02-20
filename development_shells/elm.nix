let
  pkgs = import <nixpkgs> { };
  elmPkgs = pkgs.elmPackages;
in
pkgs.mkShell {
  buildInputs = [
    elmPkgs.elm
    elmPkgs.elm-language-server
    elmPkgs.elm-live
  ];
}

