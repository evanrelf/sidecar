{
  description = "sidekick";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    haskell-overlay.url = "github:evanrelf/haskell-overlay";
  };

  outputs = inputs@{ flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs =
          import nixpkgs {
            inherit system;
            overlays = [
              inputs.gitignore.overlay
              inputs.haskell-overlay.overlay
              (import ./nix/overlays/haskell-packages.nix)
            ];
          };
      in
      rec {
        packages = {
          inherit (pkgs.haskellPackages)
            sidekick
            sidekick-ghci
            sidekick-ghci-json
            sidekick-ghci-parsers
            sidekick-shell
            ;
        };

        defaultPackage = packages.sidekick;

        devShell = packages.sidekick-shell;
      }
    );
}
