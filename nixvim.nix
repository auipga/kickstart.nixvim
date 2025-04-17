{ pkgs, lib, ... }:
let
  map = args: let
    key = builtins.elemAt args 0;
    action = builtins.elemAt args 1;
    desc = if builtins.length args > 2 then builtins.elemAt args 2 else null;
    mode = if builtins.length args > 3 then builtins.elemAt args 3 else "n";
    extraOptions = if builtins.length args > 4 then builtins.elemAt args 4 else {};
    options = extraOptions // {
      desc = desc;
    };
  in {
    inherit mode key action options;
  };
  in
{
  imports = [
    ./plugins/gitsigns.nix
    ./plugins/which-key.nix
    ./plugins/telescope.nix
    ./plugins/lsp.nix
    ./plugins/conform.nix
    ./plugins/nvim-cmp.nix
    ./plugins/todo-comments.nix
    ./plugins/mini.nix
    ./plugins/treesitter.nix

    ./plugins/kickstart/plugins/debug.nix
    ./plugins/kickstart/plugins/indent-blankline.nix
    ./plugins/kickstart/plugins/lint.nix
    ./plugins/kickstart/plugins/autopairs.nix
    ./plugins/kickstart/plugins/neo-tree.nix

    ./plugins/custom/plugins/chatgpt.nix
    ./plugins/custom/plugins/nix.nix
    ./plugins/custom/plugins/obsidian.nix
    ./plugins/custom/plugins/rust.nix
    ./plugins/custom/plugins/undotree.nix
#    ./plugins/custom/plugins/testing.nix
  ];

  # install dependencies
  home.packages = with pkgs; [
    fd
    gcc
    ripgrep
    unzip
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # List installed colorschemes with `:Telescope colorscheme`.
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html
      catppuccin = {
        enable = true;
        settings = {
          style = "catppuccin-mocha";
          styles = {
            comments = []; # fixme: comments are still italic
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#globals
    globals = {
      # Set <space> as the leader key
      # See `:help mapleader`
      mapleader = " ";
      maplocalleader = " ";

      # Set to true if you have a Nerd Font installed and selected in the terminal
      have_nerd_font = lib.mkDefault true;
    };

    # See `:help 'clipboard'`
    clipboard = {
      providers = {
        wl-copy.enable = true; # For Wayland
        xsel.enable = false; # For X11
      };

      # Sync clipboard between OS and Neovim
      #  Remove this option if you want your OS clipboard to remain independent.
      register = "unnamedplus";
    };

    # [[ Setting options ]]
    # See `:help vim.opt`
    #  For more options, you can see `:help option-list`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#opts
    opts = {
      # Show line numbers
      number = true;
      # You can also add relative line numbers, to help with jumping.
      #  Experiment for yourself to see if you like it!
      #relativenumber = true

      # Enable mouse mode, can be useful for resizing splits for example!
      mouse = "a";

      # Don't show the mode, since it's already in the statusline
      showmode = false;

      # Enable break indent
      breakindent = true;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease update time
      updatetime = 250;

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace characters in the editor
      #  See `:help 'list'`
      #  and `:help 'listchars'`
      list = true;
      # NOTE: .__raw here means that this field is raw lua code
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      # Preview substitutions live, as you type!
      inccommand = "split";

      # Show which line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor.
      scrolloff = lib.mkDefault 10;

      # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
      # instead raise a dialog asking if you wish to save the current file(s)
      # See `:help 'confirm'`
      confirm = true;

      # See `:help hlsearch`
      hlsearch = true;
    };

    # [[ Basic Keymaps ]]
    #  See `:help vim.keymap.set()`
    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      # Clear highlights on search when pressing <Esc> in normal mode
      (map [ "<Esc>"  "<cmd>nohlsearch<CR>"  "Clear highlights on search"      ])
      # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
      # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
      # is not what someone will guess without a bit more experience.
      #
      # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
      # or just use <C-\><C-n> to exit terminal mode
      (map [ "<Esc><Esc>"  "<C-\\><C-n>"  "Exit terminal mode"  "t"  ])

      # Disable arrow keys in normal mode
      (map [ "<left>"   "<cmd>echo 'Use h to move!!'<CR>"  ])
      (map [ "<right>"  "<cmd>echo 'Use l to move!!'<CR>"  ])
      (map [ "<up>"     "<cmd>echo 'Use k to move!!'<CR>"  ])
      (map [ "<down>"   "<cmd>echo 'Use j to move!!'<CR>"  ])

      # Keybinds to make split navigation easier.
      #  Use CTRL+<hjkl> to switch between windows
      #
      #  See `:help wincmd` for a list of all window commands
      (map [ "<C-h>"  "<C-w><C-h>"  "Move focus to the left window"   ])
      (map [ "<C-l>"  "<C-w><C-l>"  "Move focus to the right window"  ])
      (map [ "<C-j>"  "<C-w><C-j>"  "Move focus to the lower window"  ])
      (map [ "<C-k>"  "<C-w><C-k>"  "Move focus to the upper window"  ])

      # exit insert mode without <Esc> (https://github.com/omerxx/dotfiles/blob/c52df4/nvim/lua/config/keymaps.lua)
      (map [ "jj"  "<Esc>"  "Exit insert mode"  "i" { noremap = true; silent = true; } ])
      (map [ "jk"  "<Esc>"  "Exit insert mode"  "i" { noremap = true; silent = true; } ])
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [
      # Highlight when yanking (copying) text
      #  Try it with `yap` in normal mode
      #  See `:help vim.highlight.on_yank()`
      {
        event = ["TextYankPost"];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    plugins = {
      # Adds icons for plugins to utilize in ui
      web-devicons.enable = true;

      # Detect tabstop and shiftwidth automatically
      # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
      sleuth = {
        enable = true;
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # Useful for getting pretty icons, but requires a Nerd Font.
      nvim-web-devicons # TODO: Figure out how to configure using this with telescope
    ];

    # TODO: Figure out where to move this
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfigluapre
    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
    '';

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfigluapost
    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
