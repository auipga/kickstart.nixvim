# plugins/nix/nixd.nix
{ config, lib, osConfig, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  hostName = osConfig.networking.hostName;
  bin = lib.getExe config.programs.nixvim.plugins.lsp.servers.nixd.package;
in
{
  programs.nixvim = {
    # https://github.com/nix-community/nixd
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt#nixd
    plugins.lsp.servers.nixd.enable = true;
    plugins.lsp.servers.nixd = {
      cmd = [
        bin
        "--log=error" # error|info|debug|verbose
        "--inlay-hints=true" # default: true
        "--semantic-tokens=true" # default: false
      ];
      settings = {
        nixpkgs.expr =
          "(builtins.getFlake (toString ./.)).inputs.nixpkgs.legacyPackages.${system}";
        options.nixos.expr =
          "(builtins.getFlake (toString ./.)).nixosConfigurations.${hostName}.options";
        options.home-manager.expr =
          "(builtins.getFlake (toString ./.)).nixosConfigurations.${hostName}.options.home-manager.users.type.getSubOptions []";
        formatting = {
          command = [ "nixfmt" ];
        };
      };
    };

    # Dependencies:
    plugins.lsp.enable = true;
  };
}
