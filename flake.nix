{
  description = "Example Haskell project";

  inputs = {
    nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, haskell-nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend haskell-nix.overlay;
        project = pkgs.haskell-nix.stackProject {
          src = pkgs.haskell-nix.haskellLib.cleanGit {
            name = "example-src";
            src = ./.;
          };
          modules = [
          ];
        };
      in
      rec {
        packages = rec {
          example = project.example;
          default = example.components.exes.example;
          hello = pkgs.hello;
        };

        devShell = project.shellFor {
          exactDeps = true;
          allToolDeps = false;
          tools = {
            cabal = {};
            haskell-language-server = {};
            implicit-hie = {};
            fourmolu = {};
            hlint = {};
            stack = "2.11.1";
          };
          additional = (p: [ p.Cabal ]);
          buildInputs = [
            # extra inputs from pkgs
          ];
        };
      }
    );


  nixConfig = {
    # This sets the flake to use the IOG nix cache.
    # Nix should ask for permission before using it,
    # but remove it here if you do not want it to.
    extra-substituters = ["https://cache.iog.io"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    allow-import-from-derivation = "true";
  };

}
