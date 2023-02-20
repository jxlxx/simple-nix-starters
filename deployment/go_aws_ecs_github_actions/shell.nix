
{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    go
    gotools
    golangci-lint
    gopls
    go-outline
    gopkgs
    docker 
  ];
}

