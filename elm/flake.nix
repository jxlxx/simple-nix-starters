{
  description = "A basic elm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        elmPkgs = pkgs.elmPackages;
      in 
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            elmPkgs.elm
          ];
        };
      });
}

