{
  description = "A flake for my advent of code implementation.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    ocaml-overlay = {
      url = "github:nix-ocaml/nix-overlays";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let supportedSystems = [ inputs.flake-utils.lib.system.x86_64-darwin ];
    in inputs.flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.ocaml-overlay.overlays.${system} ];
        };

        ocamlPackages = pkgs.ocaml-ng.ocamlPackages;
        ocamlSrc = inputs.nix-filter.lib.filter {
          root = ./.;
          include = [
            "dune-project"
            (inputs.nix-filter.lib.inDirectory "bin")
            (inputs.nix-filter.lib.inDirectory "lib")
            (inputs.nix-filter.lib.inDirectory "test")
          ];
        };
        nixSrc = inputs.nix-filter.lib.filter {
          root = ./.;
          include = [ (inputs.nix-filter.lib.matchExt "nix") ];
        };

        nativeBuildInputs = [ ocamlPackages.alcotest ];

      in {
        packages = {
          aoc = ocamlPackages.buildDunePackage {
            pname = "aoc";
            version = "1";
            src = ocamlSrc;
            nativeBuildInputs = nativeBuildInputs;
            postBuild = "dune build @doc";
            postInstall = ''
              mkdir -p $out/doc/aoc/html
              cp -r _build/default/_doc/_html/* $out/doc/aoc/html
            '';
            useDune2 = true;
          };

          default = self.packages.${system}.aoc;
        };

        apps = {
          aoc = {
            type = "app";
            program = "${self.packages.${system}.aoc}/bin/aoc";
          };
          default = self.apps.${system}.aoc;
        };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.fswatch
              ocamlPackages.merlin
              ocamlPackages.ocamlformat
              ocamlPackages.ocamlformat-rpc-lib
              ocamlPackages.ocaml-lsp
              ocamlPackages.utop
            ];

            inputsFrom = [ self.packages.${system}.aoc ];
          };
        };
      });
}
