{ lib, ...}:
let
  map = import ../../../lib/mkKeymap.nix { prefix = "[N]oice "; };
in
{
  programs.nixvim = {
    # completely replaces the UI for messages, cmdline and the popupmenu
    # https://github.com/folke/noice.nvim
    # https://nix-community.github.io/nixvim/plugins/noice/index.html
    plugins.noice.enable = true;
    plugins.noice.settings = {
      # Suggested setup
      presets = {
        bottom_search = true; # use a classic bottom cmdline for search
        command_palette = true; # position the cmdline and popupmenu together
        long_message_to_split = true; # long messages will be sent to a split
        inc_rename = false; # enables an input dialog for inc-rename.nvim
        lsp_doc_border = false; # add a border to hover docs and signature help
      }
      // # Overrides
        {
          lsp_doc_border = true;
        };
    };

    keymaps = [
      (map [ "<leader>nn" "<cmd>Noice<CR>"            ""    ]) # same as 'history'
      (map [ "<leader>nh" "<cmd>Noice history<CR>"    "[H]istory"    ])
      (map [ "<leader>nl" "<cmd>Noice last<CR>"       "[L]ast"       ])
      (map [ "<leader>nd" "<cmd>Noice dismiss<CR>"    "[D]ismiss"    ])
      (map [ "<leader>nt" "<cmd>Noice telescope<CR>"  "[T]elescope"  ])
      (map [ "<leader>ne" "<cmd>Noice errors<CR>"     "[E]rrors"     ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>n";
        group = "[N]oice";
        mode = [ "n" ];
      }
    ];

    # Integrations
    plugins.lualine.settings = {
      sections = {
        # lualine_x see ./lualine.nix
      };
    };

    # Optional dependencies:
    # plugins.nui.enable = true;
    # https://github.com/rcarriga/nvim-notify/
    # https://nix-community.github.io/nixvim/plugins/notify/index.html
    plugins.notify.enable = true;
    plugins.notify.settings = {
      render = "wrapped-default"; # default: default
      stages = "fade"; # default: fade_in_slide_out
    };
    # plugins.telescope.enable = true;
    # plugins.cmp.enable = true;
    # plugins.lsp.enable = true;
  };
}
