{
  description = "A flake that lets you override your usual git config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            ];
        shellHook = ''
            export GIT_COMMITTER_NAME="<<NAME>>"
            export GIT_COMMITTER_EMAIL="<<EMAIL>>"
            export GIT_AUTHOR_NAME="<<NAME>>"
            export GIT_AUTHOR_EMAIL="<<EMAIL>>"
            export GIT_SSH_COMMAND="ssh -i ~/path/to/private/key"
          '';
        };
      });
}

