{ lib, ... }:
{
  programs.nixvim = {
    plugins.trouble.enable = true;

    # Integrations
    plugins.lualine.settings = {
      extensions = lib.mkAfter [ "trouble" ];
    };
  };
}
