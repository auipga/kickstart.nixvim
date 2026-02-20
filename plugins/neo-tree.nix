{ lib, ... }:
let
  map = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://github.com/nvim-neo-tree/neo-tree.nvim
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html
    plugins.neo-tree = {
      enable = true;

      settings = {
        filesystem = {
          window = {
            mappings = {
              "\\" = "close_window";
              "<F4>" = "close_window";
            };
          };
        };
      };
    };

    keymaps = [
      (map [ "\\"  "<cmd>Neotree reveal<cr>"  "NeoTree reveal"  ])
      (map [ "<F4>"  "<cmd>Neotree reveal<cr>"  "NeoTree reveal"  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      extensions           = lib.mkAfter [ "neo-tree" ];
      options.ignore_focus = lib.mkAfter [ "neo-tree" ];
    };
  };
}
