{ lib, ... }:
{
  programs.nixvim = {
    # https://github.com/folke/trouble.nvim/
    # https://nix-community.github.io/nixvim/plugins/trouble/index.html
    plugins.trouble.enable = true;

    # Integrations
    plugins.lualine.settings = {
      extensions = lib.mkAfter [ "trouble" ];
    };
  };
}
