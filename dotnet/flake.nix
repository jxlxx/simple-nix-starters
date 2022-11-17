{ description = "A flake to develop and build a dotnet project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
         devShell = pkgs.mkShell {
           buildInputs = [
             pkgs.dotnet-sdk
             # pkgs.omnisharp-roslyn # LSP for C# -- see fsautocomplete comment below for F# LSP.
           ];
           shellHook = ''
             # Set up environment variables to play nice with per-project
             # dotnet tools and dotnet packages.
             # For example, install fsautocomplete with
             # `dotnet tool install fsautocomplete --tool-path=$TOOLPATH `
             # (fsautocomplete is not in nixpkgs)
             # Note that the only way to specify where tools are installed is
             # with the `--tool-path` option.

             export TOOLPATH="$(pwd)/.dotnet"
             export NUGET_PACKAGES="$(pwd)/.nuget"
             export PATH="$(pwd)/.dotnet:$PATH"
             # export DOTNET_ROOT="${pkgs.dotnet-sdk}" # if you can't find libhostfxr.so, might help
           '';
         };
      });
}
