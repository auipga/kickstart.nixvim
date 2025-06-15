{
  description = "Kick-start Neovim config packaged with nixvim (flake-parts)";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url       = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url  = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, nixvim, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { system, ... }:
        let
          # 1 ▸ pkgs with the nixvim overlay baked in
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nixvim.overlays.default ];
          };

          # 2 ▸ your existing nixvim module (folder or single file)
          myNixvimModule = import ./nixvim.nix;

          # 3 ▸ build a complete Neovim derivation from that module
          nvimDrv = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = myNixvimModule;
          };
        in
        {
          ##################################################
          ## A. buildable outputs
          ##################################################
          packages = {
            nvim    = nvimDrv;
            default = nvimDrv;
          };

          ##################################################
          ## B. runnable app → `nix run .#nvim`
          ##################################################
          apps = {
            nvim = {
              type = "app";
              program = "${nvimDrv}/bin/nvim";
            };
            default = self.apps.${system}.nvim;
          };

          ##################################################
          ## C. dev shell with the same Neovim pre-installed
          ##################################################
          devShells.default = pkgs.mkShell {
            inputsFrom = [ nvimDrv ];
            shellHook = ''
              alias nvim="${nvimDrv}/bin/nvim"
              echo "🟢  Dev shell ready – launch with:  nvim"
            '';
          };
        };
    };
}
