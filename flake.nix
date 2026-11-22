{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, ... }:
        let
          # github.com/Mic92/nix-update/issues/687: Nix >= 2.35 fetches flake sources lazily, which breaks nix-update
          nix-update = pkgs.nix-update.override {
            nix = pkgs.nixVersions.nix_2_34;
          };
        in
        {
          packages = {
            inherit nix-update;
            default = nix-update;
          };
        };
    };
}
