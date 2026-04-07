{ lib, ... }:
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://github.com/nvim-neo-tree/neo-tree.nvim
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html
    plugins.neo-tree = {
      enable = true;

      settings = {
        sort_case_insensitive = true; # default: false

        sources = [
          "filesystem"
          "buffers"
          "git_status"
          "document_symbols"
        ];

        source_selector = {
          winbar = true; # default: false
          sources = [
            { source = "filesystem"; }
            { source = "buffers"; }
            { source = "git_status"; }
            { source = "document_symbols"; }
          ];
        };

        filesystem = {
          filtered_items = {
            hide_dotfiles = false; # default: true
            never_show = [
              ".git"
            ];
          };

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
      (kmap [ "\\"  "<cmd>Neotree reveal<cr>"  "NeoTree reveal"  ])
      (kmap [ "<F4>"  "<cmd>Neotree reveal<cr>"  "NeoTree reveal"  ])
      (kmap [ "<leader>g"  "<cmd>Neotree float git_status<CR>"  "NeoTree / Git"  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      extensions           = lib.mkAfter [ "neo-tree" ];
      options.ignore_focus = lib.mkAfter [ "neo-tree" ];
    };
  };
}
