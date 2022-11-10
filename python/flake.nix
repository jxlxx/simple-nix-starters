{
  description = "A basic python flake using the poetry package manager";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs,flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.python39Packages.poetry
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
          ];
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.zlib}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/libstdc++.so.6:$LD_LIBRARY_PATH
            export IPYTHONDIR=$(pwd)/.ipython
          '';
        };
      });
}
