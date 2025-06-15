{
  description = "Kick-start Neovim config packaged with nixvim (flake-utils)";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url      = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # ----- 1 ▸ pkgs with the nixvim overlay baked in ------------------
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nixvim.overlays.default ];
        };

        # ----- 2 ▸ your *existing* nixvim module --------------------------
        myNixvimModule = import ./nixvim.nix;

        # ----- 3 ▸ turn that module into a buildable Neovim --------------
        nvimDrv =
          nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = myNixvimModule;
          };
      in
      {
        ##################################################################
        ##  A.  “Packages”  — things you can `nix build` or `nix run`
        ##################################################################
        packages = {
          nvim    = nvimDrv;   # → nix build .#nvim   (store path output)
          default = nvimDrv;   # → nix build .        (shorthand)
        };

        ##################################################################
        ##  B.  “Apps”  — executable wrappers for `nix run`
        ##################################################################
        apps = {
          nvim = flake-utils.lib.mkApp {
            drv  = nvimDrv;
            name = "nvim";
          };
          default = self.apps.${system}.nvim;
        };

        ##################################################################
        ##  C.  Dev-shell for rapid iteration (optional)
        ##################################################################
        devShells.default = pkgs.mkShell {
          inputsFrom = [ nvimDrv ];
          shellHook = ''
            alias nvim="${nvimDrv}/bin/nvim"
            echo "🟢  Dev shell ready – launch with:  nvim"
          '';
        };
      }
    );
}
