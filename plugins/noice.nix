{ config, lib, pkgs, ... }:
let
  kmap = import ../lib/mkKeymap.nix { prefix = "[N]oice "; };
in
{
  programs.nixvim = {
    # completely replaces the UI for messages, cmdline and the popupmenu
    # https://github.com/folke/noice.nvim
    # https://nix-community.github.io/nixvim/plugins/noice/index.html
    plugins.noice.enable = true;

    plugins.noice.settings = lib.recursiveUpdate
      # Suggested setup
      # https://github.com/folke/noice.nvim/?tab=readme-ov-file#-installation
      {
        lsp = {
          # override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true && config.programs.nixvim.plugins.cmp.enable;
          };
        };
        # you can enable a preset for easier configuration
        presets = {
          bottom_search = true; # use a classic bottom cmdline for search
          command_palette = true; # position the cmdline and popupmenu together
          long_message_to_split = true; # long messages will be sent to a split
          inc_rename = false; # enables an input dialog for inc-rename.nvim
          lsp_doc_border = false; # add a border to hover docs and signature help
        };
      }

      # Personal setup
      {
        presets = {
          lsp_doc_border = true;
        };

        # alternative to fidget
        lsp.progress.enabled = true; # default: true
      };

    keymaps = [
      (kmap [ "<leader>nn" "<cmd>Noice<CR>"            ""    ]) # same as 'history'
      (kmap [ "<leader>nh" "<cmd>Noice history<CR>"    "[H]istory"    ])
      (kmap [ "<leader>nl" "<cmd>Noice last<CR>"       "[L]ast"       ])
      (kmap [ "<leader>nd" "<cmd>Noice dismiss<CR>"    "[D]ismiss"    ])
      (kmap [ "<leader>nt" "<cmd>Noice telescope<CR>"  "[T]elescope"  ])
      (kmap [ "<leader>ne" "<cmd>Noice errors<CR>"     "[E]rrors"     ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>n";
        group = "[N]oice";
        mode = [ "n" ];
      }
    ];

    # Dependencies:
    plugins.treesitter = {
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; lib.mkAfter [
        vim
        regex
        lua
        bash
        markdown
        markdown_inline
      ];
    };

    # Optional dependencies:
    # plugins.nui.enable = true;
    # https://github.com/rcarriga/nvim-notify/
    # https://nix-community.github.io/nixvim/plugins/notify/index.html
    plugins.notify.enable = false;
    plugins.notify.settings = {
      render = "wrapped-default"; # default|minimal|simple|compact|wrapped-compact|wrapped-default
      stages = "fade"; # fade_in_slide_out|fade|slide|static
    };
    # plugins.telescope.enable = true;
    # plugins.cmp.enable = true;
    # plugins.lsp.enable = true;
  };
}
