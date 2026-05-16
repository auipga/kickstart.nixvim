# plugins/codecompanion/integrations.nix
{ lib, ... }:
{
  programs.nixvim = {
    # Integrations
    plugins.lualine.settings = {
      options.ignore_focus = lib.mkAfter [ "codecompanion" ];
    };
    plugins.render-markdown.settings = {
      file_types = [ "codecompanion" ];

      # Replace tags with icons:
      # Nerdfont icons:  󰈔   󰈤 󰘓  󰈙   󰈠 󰈞 󱝴 󱅷 
      html.tag = {
        file = {
          icon = "󰈙 ";
          highlight = "Normal";
        };
        rules = {
          icon = "󰘓 ";
          highlight = "Normal";
        };
        group = {
          icon = " ";
          highlight = "Normal";
        };
        tool = {
          icon = " ";
          highlight = "Normal";
        };
        buf = {
          icon = "󰷊 ";
          highlight = "Normal";
        };
        var = {
          icon = "󰌕 ";
          highlight = "Normal";
        };
      };
    };
  };
}
