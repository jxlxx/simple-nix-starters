let
  pkgs = import <nixpkgs> { };
  hsPkgs = pkgs.haskellPackages;
in
pkgs.mkShell {
  buildInputs = [
    hsPkgs.ghcid
    hsPkgs.haskell-language-server
    hsPkgs.cabal-install
  ];
}

