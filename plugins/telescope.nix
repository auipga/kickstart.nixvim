let
  kmapR = import ../lib/mkKeymap.nix { raw = true; };
  kmapP = import ../lib/mkKeymap.nix { prefix = "[S]earch "; };
  kmapPR = import ../lib/mkKeymap.nix { prefix = "[S]earch "; raw = true; };
  mkPluginKeymaps = import ../lib/mkPluginKeymap.nix { descInOptions = true; };
in
{
  programs.nixvim = {
    # Fuzzy Finder (files, lsp, etc)
    # https://github.com/nvim-telescope/telescope.nvim
    # https://nix-community.github.io/nixvim/plugins/telescope/index.html
    plugins.telescope = {
      enable = true;

      # Enable extensions
      # https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
      extensions = {
        # https://github.com/nvim-telescope/telescope-file-browser.nvim
        file-browser.enable = true;

        # https://github.com/nvim-telescope/telescope-frecency.nvim
        frecency.enable = true;

        # https://github.com/nvim-telescope/telescope-fzf-native.nvim
        fzf-native.enable = true;

        # https://github.com/nvim-telescope/telescope-live-grep-args.nvim
        live-grep-args.enable = true;
        live-grep-args.settings = {
          auto_quoting = true;
          mappings = {
            i = {
              "<C-k>".__raw = ''
                require("telescope-live-grep-args.actions").quote_prompt()
              '';
              "<C-i>".__raw = ''
                require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })
              '';
              # freeze the current list and start a fuzzy search in the frozen list
              "<C-space>".__raw = ''
                require("telescope.actions").to_fuzzy_refine
              '';
            };
          };
        };

        # https://github.com/nvim-telescope/telescope-media-files.nvim
        # media-files.enable = true;

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
        [ "<leader>sG"        "live_grep_args"   "[S]earch by [G]rep + Args"    ]
        [ "<leader>sd"        "diagnostics"      "[S]earch [D]iagnostics"       ]
        [ "<leader>sr"        "resume"           "[S]earch [R]esume"            ]
        [ "<leader>s."        "oldfiles"         "[S]earch Recent Files"        ]
        [ "<leader><leader>"  "buffers"          "[ ] Find existing buffers"    ]
        [ "<leader>sc"        "command_history"  "[S]earch [C]ommand History"   ]
        [ "<leader>su"        "undo"             "[S]earch [U]ndo History"      ]
      ];

      settings = {
        pickers.colorscheme = {
          enable_preview = true;
          ignore_builtins = true;
        };
        extensions = {
          # ui-select.__raw = "{ require('telescope.themes').get_dropdown() }";
        };
      };
    };

    keymaps = [
      # Slightly advanced example of overriding default behavior and theme
        # You can pass additional configuration to Telescope to change the theme, layout, etc.
      (kmapR [ "<leader>/" ''
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
      (kmapPR [ "<leader>s/"
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
      (kmapPR [ "<leader>snv" ''
          function()
            require('telescope.builtin').find_files {
              cwd = "$HOME/nixos-config/kickstart.nixvim/"
            }
          end
        ''  "[N]ix[v]im files"  ])
      # Shortcut for searching your NixOS configuration files
      (kmapPR [ "<leader>sno" ''
          function()
            require('telescope.builtin').find_files {
              cwd = "$HOME/nixos-config/",
              find_command = {
                "fd", "--type", "f",
                "--exclude", "home-manager",
                "--exclude", "kickstart.nixvim",
              },
            }
          end
      ''  "[N]ix[O]S files"  ])
      # Shortcut for searching your home-manager configuration files
      (kmapPR [ "<leader>snh" ''
          function()
            require('telescope.builtin').find_files {
              cwd = "$HOME/nixos-config/home-manager",
            }
          end
        ''  "[N]ixOS [h]ome-manager files"  ])
       # Shortcut for searching vim_options
       (kmapP  [ "<leader>so"  "<cmd>Telescope vim_options<cr>"  "vim_[o]ptions"  ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>s";
        group = "[S]earch";
      }
      {
        __unkeyed-1 = "<leader>sn";
        group = "[S]earch [N]ix config";
      }
    ];
  };
}
