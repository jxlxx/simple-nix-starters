{
  description = "A basic haskell flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        hsPkgs = pkgs.haskellPackages;
      in 
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            hsPkgs.haskell-language-server
            hsPkgs.ghcid
            hsPkgs.cabal-install
          ];
        };
      });
}

