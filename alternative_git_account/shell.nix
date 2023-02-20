
{ pkgs ? import <nixpkgs> { } }:
  with pkgs;
  mkShell {
    buildInputs = [
      nixpkgs-fmt
    ];
  shellHook = ''
    export GIT_COMMITTER_NAME="<NAME>"
    export GIT_COMMITTER_EMAIL="<EMAIL>"
    export GIT_AUTHOR_NAME="<NAME>"
    export GIT_AUTHOR_EMAIL="<EMAIL>"
    export GIT_SSH_COMMAND="ssh -i ~/path/to/private/key"
  '';
}

