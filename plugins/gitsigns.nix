let
  map = import ../lib/mkKeymap.nix { };
  mapP = import ../lib/mkKeymap.nix { prefix = "git "; };
  mapPR = import ../lib/mkKeymap.nix { prefix = "git "; raw = true; };
  mapR = import ../lib/mkKeymap.nix { raw = true; };
in
{
  programs.nixvim = {
    # Adds git related signs to the gutter, as well as utilities for managing changes
    # See `:help gitsigns` to understand what the configuration keys do
    # https://nix-community.github.io/nixvim/plugins/gitsigns/index.html
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "+";
          change.text = "~";
          changedelete.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          untracked.text = "┆";
        };
      };
    };

    keymaps = [
      # Navigation
      (mapR [ "]c" ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              require('gitsigns').nav_hunk 'next'
            end
          end
        '' "Jump to next git [c]hange" ])
      (mapR [ "[c" ''
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
      (mapPR [ "<leader>hs" ''
          function()
            require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '' "[s]tage hunk" "v" ])
      (mapPR [ "<leader>hr" ''
          function()
            require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '' "[r]eset hunk" "v" ])

      # normal mode
      (mapP  [ "<leader>hs"  "<cmd>Gitsigns stage_hunk<CR>"       "[s]tage hunk"       ])
      (mapP  [ "<leader>hr"  "<cmd>Gitsigns reset_hunk<CR>"       "[r]eset hunk"       ])
      (mapP  [ "<leader>hS"  "<cmd>Gitsigns stage_buffer<CR>"     "[S]tage buffer"     ])
      (mapP  [ "<leader>hu"  "<cmd>Gitsigns undo_stage_hunk<CR>"  "[u]ndo stage hunk"  ]) # deprecated, use stage_hunk which also toggles
      (mapP  [ "<leader>hR"  "<cmd>Gitsigns reset_buffer<CR>"     "[R]eset buffer"     ])
      (mapP  [ "<leader>hp"  "<cmd>Gitsigns preview_hunk<CR>"     "[p]review hunk"     ])

      # official gitsigns
      (mapP  [ "<leader>hi"  "<cmd>Gitsigns preview_hunk_inline<CR>"  "preview hunk [i]nline"  ])
      (mapPR [ "<leader>hb"  ''
          function()
            require('gitsigns').blame_line({ full = true })
          end
        '' "[b]lame line" ])
      (mapP  [ "<leader>hd"  "<cmd>Gitsigns diffthis<CR>"       "[d]iff against index"        ])
      (mapPR [ "<leader>hD"  ''
          function()
            require('gitsigns').diffthis '@'
          end
        ''  "[D]iff against last commit"  ])
      (mapP  [ "<leader>hQ"  "<cmd>Gitsigns setqflist all<CR>"  "[Q]uickfix List (all)"       ])
      (mapP  [ "<leader>hq"  "<cmd>Gitsigns setqflist<CR>"      "[q]uickfix List"             ])

      # auipga
      (mapP  [ "<leader>hL"  "<cmd>Gitsigns setloclist all<CR>"  "[L]ocation List (all)"  ])
      (mapP  [ "<leader>hl"  "<cmd>Gitsigns setloclist<CR>"      "[l]ocation List"        ])

      # Toggles
      (map [ "<leader>tb"  "<cmd>Gitsigns toggle_current_line_blame<CR>"  "[T]oggle git show [b]lame line"   ])
      (map [ "<leader>td"  "<cmd>Gitsigns toggle_deleted<CR>"             "[T]oggle git show [d]eleted"      ]) # deprecated
      (map [ "<leader>tw"  "<cmd>Gitsigns toggle_word_diff<CR>"           "[T]oggle intra-line [w]ord-diff"  ])

      # Text object
      # official gitsigns
      (map [ "<leader>hh"  "<cmd>Gitsigns select_hunk<CR>"  "Select hunks as a text object"  [ "o" "x" ]  ]) # changed from: <leader>ih
    ];
  };
}
