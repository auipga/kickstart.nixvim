{ config, lib, ... }:
{
  programs.nixvim = {
    # Useful plugin to show you pending keybinds.
    # https://nix-community.github.io/nixvim/plugins/which-key/index.html
    plugins.which-key = {
      enable = true;

      # Document existing key chains
      settings = {
        # Expand groups when <= n mappings.
        expand = 0;

        icons = lib.mkMerge [
          (if config.programs.nixvim.globals.have_nerd_font then
          # don’t override keys, fallback to default
            { }
          else {
            keys = {
              Up = "<Up> ";
              Down = "<Down> ";
              Left = "<Left> ";
              Right = "<Right> ";
              C = "<C-…> ";
              M = "<M-…> ";
              D = "<D-…> ";
              S = "<S-…> ";
              CR = "<CR> ";
              Esc = "<Esc> ";
              ScrollWheelDown = "<ScrollWheelDown> ";
              ScrollWheelUp = "<ScrollWheelUp> ";
              NL = "<NL> ";
              BS = "<BS> ";
              Space = "<Space> ";
              Tab = "<Tab> ";
              F1 = "<F1>";
              F2 = "<F2>";
              F3 = "<F3>";
              F4 = "<F4>";
              F5 = "<F5>";
              F6 = "<F6>";
              F7 = "<F7>";
              F8 = "<F8>";
              F9 = "<F9>";
              F10 = "<F10>";
              F11 = "<F11>";
              F12 = "<F12>";
            };
          })
          {
            # space to merge other keys below settings.icons
          }
        ];

        preset = "modern"; # bordered, bottom, wide, multi column
        # preset = "helix"; # bordered, bottom right, single column

        sort = [
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
        ];

        spec = [
          {
            __unkeyed-1 = "<leader>c";
            group = "[C]ode / [C]hatGPT";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "[S]earch";
          }
        ];
      };
    };
  };
}
