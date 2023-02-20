{
  description = "A flake to develop and build a go project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        
        goBuild = pkgs.buildGoModule {
          name = "CONTAINER_NAME";
          src = ./.;
          vendorHash = null;
        };
        
        dockerImage = pkgs.dockerTools.buildImage {
          name = "CONTAINER_NAME";
          config = {
            Cmd = [ "${goBuild}/bin/CONTAINER_NAME" ];
          };
        };
        
      in
      {
        packages = {
          goPackage = goBuild;
          docker = dockerImage;     
        };
        defaultPackage = dockerImage;
        devShells.default = import ./shell.nix { inherit pkgs; };            
    });
}
