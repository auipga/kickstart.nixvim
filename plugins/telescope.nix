let
  mapR = import ../lib/mkKeymap.nix { raw = true; };
  mapPR = import ../lib/mkKeymap.nix { prefix = "[S]earch "; raw = true; };
  mkPluginKeymaps = import ../lib/mkPluginKeymap.nix { descInOptions = true; };
in
{
  programs.nixvim = {
    # Fuzzy Finder (files, lsp, etc)
    # https://nix-community.github.io/nixvim/plugins/telescope/index.html
    plugins.telescope = {
      # Telescope is a fuzzy finder that comes with a lot of different things that
      # it can fuzzy find! It's more than just a "file finder", it can search
      # many different aspects of Neovim, your workspace, LSP, and more!
      #
      # The easiest way to use Telescope, is to start by doing something like:
      #  :Telescope help_tags
      #
      # After running this command, a window will open up and you're able to
      # type in the prompt window. You'll see a list of `help_tags` options and
      # a corresponding preview of the help.
      #
      # Two important keymaps to use while in Telescope are:
      #  - Insert mode: <c-/>
      #  - Normal mode: ?
      #
      # This opens a window that shows you all of the keymaps for the current
      # Telescope picker. This is really useful to discover what Telescope can
      # do as well as how to actually do it!
      #
      # [[ Configure Telescope ]]
      # See `:help telescope` and `:help telescope.setup()`
      enable = true;

      # Enable Telescope extensions
      # https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
      extensions = {
        # https://github.com/nvim-telescope/telescope-file-browser.nvim
        file-browser.enable = true;
        # https://github.com/nvim-telescope/telescope-frecency.nvim
        frecency.enable = true;
        # https://github.com/nvim-telescope/telescope-fzf-native.nvim
        fzf-native.enable = true;
        # https://github.com/nvim-telescope/telescope-fzy-native.nvim
        # fzy-native.enable = true;
        # https://github.com/nvim-telescope/telescope-live-grep-args.nvim
        # live-grep-args.enable = true;
        # https://github.com/mrcjkb/telescope-manix
        # manix.enable = true;
        # https://github.com/nvim-telescope/telescope-media-files.nvim
        # media-files.enable = true;
        # https://github.com/ahmedkhalf/project.nvim
        # project.enable = true;
        # https://github.com/nvim-telescope/telescope-ui-select.nvim
        ui-select.enable = true;
        # https://github.com/debugloop/telescope-undo.nvim
        undo.enable = true;
      };

      # You can put your default mappings / updates / etc. in here
      #  See `:help telescope.builtin`
      keymaps = mkPluginKeymaps [
        [ "<leader>sh"        "help_tags"        "[S]earch [H]elp"              ]
        [ "<leader>sk"        "keymaps"          "[S]earch [K]eymaps"           ]
        [ "<leader>sf"        "find_files"       "[S]earch [F]iles"             ]
        # replaced by telescope-picker-list:
        # [ "<leader>ss"        "builtin"          "[S]earch [S]elect Telescope"  ]
        [ "<leader>sw"        "grep_string"      "[S]earch current [W]ord"      ]
        [ "<leader>sg"        "live_grep"        "[S]earch by [G]rep"           ]
        [ "<leader>sd"        "diagnostics"      "[S]earch [D]iagnostics"       ]
        [ "<leader>sr"        "resume"           "[S]earch [R]esume"            ]
        [ "<leader>s."        "oldfiles"         "[S]earch Recent Files"        ]
        [ "<leader><leader>"  "buffers"          "[ ] Find existing buffers"    ]
        [ "<leader>sc"        "command_history"  "[S]earch [C]ommand History"   ]
        [ "<leader>su"        "undo"             "[S]earch [U]ndo History"      ]
      ];
      settings = {
        pickers.colorscheme.enable_preview = true;
        extensions = {
          ui-select.__raw = "{ require('telescope.themes').get_dropdown() }";
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      # Slightly advanced example of overriding default behavior and theme
        # You can pass additional configuration to Telescope to change the theme, layout, etc.
      (mapR [ "<leader>/" ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(
              require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false
              }
            )
          end
        ''  "[/] Fuzzily search in current buffer"  ])
        # It's also possible to pass additional configuration options.
      (mapPR [ "<leader>s/"
        #  See `:help telescope.builtin.live_grep()` for information about particular keys
        ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files'
            }
          end
        ''  "[/] in Open Files"  ])
      # Shortcut for searching your Nixvim configuration files
      (mapPR [ "<leader>sv" ''
          function()
            require('telescope.builtin').find_files {
              cwd = "$HOME/nixos-config/kickstart.nixvim/"
            }
          end
        ''  "Nix[v]im files"  ])
      # Shortcut for searching your NixOS configuration files
      (mapPR [ "<leader>sn" ''
          function()
            require('telescope.builtin').find_files {
              cwd = "$HOME/nixos-config/",
              find_command = {
                "fd", "--type", "f",
                "--exclude", "kickstart.nixvim"
              }
            }
          end
        ''  "[N]ixOS files"  ])
    ];
  };
}
