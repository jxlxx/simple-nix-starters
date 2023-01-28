{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.julia-bin
          ];
          shellHook = ''
            mkdir -p "$(pwd)/opt"
            export JULIA_DEPOT_PATH="$(pwd)/opt"
          '';
        };
      });
}
