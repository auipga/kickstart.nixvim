{ config, ... }:
let
  kmap = import ../lib/mkKeymap.nix { };
  kmapP = import ../lib/mkKeymap.nix { prefix = "git "; };
  kmapPR = import ../lib/mkKeymap.nix { prefix = "git "; raw = true; };
  kmapR = import ../lib/mkKeymap.nix { raw = true; };
in
{
  programs.nixvim = {
    # Adds git related signs to the gutter, as well as utilities for managing changes
    # See `:help gitsigns` to understand what the configuration keys do
    # https://nix-community.github.io/nixvim/plugins/gitsigns/index.html
    plugins.gitsigns = {
      enable = true;
      settings = {
        diff_opts = {
          # algorithm = "myers";     # the default algorithm
          # algorithm = "minimal";   # spend extra time to generate the smallest possible diff
          # algorithm = "patience";  # patience diff algorithm
          # algorithm = "histogram"; # histogram diff algorithm
        };
        signs = {
          add.text = "+";
          change.text = "~";
          changedelete.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          untracked.text = "┆";
        };
        trouble = config.programs.nixvim.plugins.trouble.enable;
      };
    };

    keymaps = [
      # Navigation
      (kmapR [ "]c" ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              require('gitsigns').nav_hunk 'next'
            end
          end
        '' "Jump to next git [c]hange" ])
      (kmapR [ "[c" ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              require('gitsigns').nav_hunk 'prev'
            end
          end
        '' "Jump to previous git [c]hange" ])

      # Actions
      # visual mode
      (kmapPR [ "<leader>hs" ''
          function()
            require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '' "[s]tage hunk" "v" ])
      (kmapPR [ "<leader>hr" ''
          function()
            require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '' "[r]eset hunk" "v" ])

      # normal mode
      (kmapP  [ "<leader>hs"  "<cmd>Gitsigns stage_hunk<CR>"       "[s]tage hunk"       ])
      (kmapP  [ "<leader>hr"  "<cmd>Gitsigns reset_hunk<CR>"       "[r]eset hunk"       ])
      (kmapP  [ "<leader>hS"  "<cmd>Gitsigns stage_buffer<CR>"     "[S]tage buffer"     ])
      (kmapP  [ "<leader>hu"  "<cmd>Gitsigns undo_stage_hunk<CR>"  "[u]ndo stage hunk"  ]) # deprecated, use stage_hunk which also toggles
      (kmapP  [ "<leader>hR"  "<cmd>Gitsigns reset_buffer<CR>"     "[R]eset buffer"     ])
      (kmapP  [ "<leader>hp"  "<cmd>Gitsigns preview_hunk<CR>"     "[p]review hunk"     ])

      # official gitsigns
      (kmapP  [ "<leader>hi"  "<cmd>Gitsigns preview_hunk_inline<CR>"  "preview hunk [i]nline"  ])
      (kmapPR [ "<leader>hb"  ''
          function()
            require('gitsigns').blame_line({ full = true })
          end
        '' "[b]lame line" ])
      (kmapP  [ "<leader>hd"  "<cmd>Gitsigns diffthis<CR>"       "[d]iff against index"        ])
      (kmapPR [ "<leader>hD"  ''
          function()
            require('gitsigns').diffthis '@'
          end
        ''  "[D]iff against last commit"  ])
      (kmapP  [ "<leader>hQ"  "<cmd>Gitsigns setqflist all<CR>"  "[Q]uickfix List (all)"       ])
      (kmapP  [ "<leader>hq"  "<cmd>Gitsigns setqflist<CR>"      "[q]uickfix List"             ])

      # auipga
      (kmapP  [ "<leader>hL"  "<cmd>Gitsigns setloclist all<CR>"  "[L]ocation List (all)"  ])
      (kmapP  [ "<leader>hl"  "<cmd>Gitsigns setloclist<CR>"      "[l]ocation List"        ])

      # Toggles
      (kmap [ "<leader>tb"  "<cmd>Gitsigns toggle_current_line_blame<CR>"  "[T]oggle git show [b]lame line"   ])
      (kmap [ "<leader>td"  "<cmd>Gitsigns toggle_deleted<CR>"             "[T]oggle git show [d]eleted"      ]) # deprecated
      (kmap [ "<leader>tw"  "<cmd>Gitsigns toggle_word_diff<CR>"           "[T]oggle intra-line [w]ord-diff"  ])

      # Text object
      # official gitsigns
      (kmap [ "<leader>hh"  "<cmd>Gitsigns select_hunk<CR>"  "Select hunks as a text object"  [ "o" "x" ]  ]) # changed from: <leader>ih
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>t";
        group = "[T]oggle";
      }
      {
        __unkeyed-1 = "<leader>h";
        group = "Git [H]unk";
        mode = [
          "n" # normal mode
          "v" # visual mode
          "o" # operator-pending mode
          # "x" # visual mode after an operator is executed
        ];
      }
    ];
  };
}
