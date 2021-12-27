{
  description = "A flake for the Joule extension";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?ref=master;
  	flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with nixpkgs;
  	flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system: let
        pkgs = legacyPackages."${system}";
      in
        with pkgs;
        rec {
          # `nix build`
          packages.joule = mkYarnPackage {
            pname = "joule";
            src = ./.;
    		  	packageJSON = ./package.json;
    		  	yarnLock = ./yarn.lock;
    		  	yarnNix = ./yarn.nix;
          };
          
          defaultPackage = packages.joule;

          # `nix run`
          apps.joule = flake-utils.lib.mkApp {
            drv = packages.joule;
          };
          defaultApp = apps.joule;

          # `nix develop`
          devShell = mkShell { 
            buildInputs = [ 
              yarn2nix 
              yarn 
            ]
;          };
        }
    );
}
