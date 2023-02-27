{
  description = "bounded-queue";

  inputs = { 
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        config = {
          allowUnfree = true;
        };
        overlays = [
        ];
        pkgs = import nixpkgs { 
          inherit config overlays system; 
        };
      in rec {
        # you can use this for debugging purposes within a nix repl
        # `nix repl`
        # `:lf .#'
        # `_pkgs.<arch>.<package-name>`
        _pkgs = pkgs;

        fourmolu = pkgs.haskellPackages.callHackage "fourmolu" "0.6.0.0" {};

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            fourmolu
            haskellPackages.cabal-install
            haskellPackages.ghc
            haskellPackages.implicit-hie
            haskellPackages.haskell-language-server
            haskellPackages.cabal2nix
            haskellPackages.cabal-fmt
          ];
        };
      }
    );
}
