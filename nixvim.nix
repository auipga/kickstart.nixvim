{ lib, config, ... }:
let
  map = import ./lib/mkKeymap.nix { };
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

    # ./plugins/debug.nix # directly imported by home-manager/modules/coding-rust.nix and coding-php.nix
    ./plugins/indent-blankline.nix
    ./plugins/lint.nix
    ./plugins/autopairs.nix
    ./plugins/neo-tree.nix

    ./plugins/_.nix
    ./plugins/ai-chatgpt.nix
    ./plugins/ai-copilot.nix
    ./plugins/ale.nix
    ./plugins/codecompanion/default.nix
    ./plugins/codecompanion/extensions/history.nix
    ./plugins/codecompanion/extensions/mcp-hub.nix
    ./plugins/codecompanion/extensions/spinner.nix
    ./plugins/codecompanion/extensions/vectorcode.nix
    ./plugins/auto-session.nix
    # ./plugins/cmp-ai.nix
    ./plugins/dial.nix
    # ./plugins/easypick.nix
    ./plugins/lazygit.nix
    ./plugins/llama.nix
    ./plugins/lualine.nix
    ./plugins/nix/default.nix
    ./plugins/noice.nix
    ./plugins/obsidian.nix
    # ./plugins/php.nix # directly imported by home-manager/modules/coding-php.nix
    ./plugins/render-markdown.nix
    ./plugins/repeat.nix
    # ./plugins/rust.nix # directly imported by home-manager/modules/coding-rust.nix
    ./plugins/snacks.nix
    ./plugins/surround.nix
    ./plugins/telescope-picker-list.nix
    ./plugins/terminal.nix
    ./plugins/terminal.autorun-project-tool.nix
    ./plugins/treesitter-autotag.nix
    ./plugins/treesitter-context.nix
    ./plugins/treesitter-textobjects.nix
    ./plugins/trouble.nix
    ./plugins/undotree.nix
    ./plugins/wakatime.nix
    ./plugins/testing.nix
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
          flavour = config.catppuccin.flavor;
          transparent_background = true;
          no_italic = true; # concerns comments and conditionals
          dim_inactive.enabled = false;
        };
      };
    };

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
    opts = {
      # Show line numbers
      number = true;
      # Add relative line numbers, to help with jumping.
      relativenumber = false;

      # Enable mouse mode, can be useful for resizing splits for example!
      mouse = "a";

      # Don't show the mode, since it's already in the statusline
      showmode = false;

      # Enable break indent
      breakindent = true;

      # Save undo history across sessions
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace characters in the editor
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      # Preview substitutions live, as you type!
      inccommand = "split";

      # Highlight line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor.
      scrolloff = lib.mkDefault 0;
      # Minimal number of screen lines to keep left and right the cursor.
      sidescrolloff = 8;

      # Text wrapping
      wrap = false;

      # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
      # instead raise a dialog asking if you wish to save the current file(s)
      confirm = true;

      # Highlight search matches
      hlsearch = true;

      # Show upto 9 columns of folds
      foldcolumn = "auto:9";
      # Start with no folds closed
      foldlevelstart = 99;

      # show filename as window title
      title = false;
    };

    diagnostic.settings = {
      # Show virtual line diagnostics
      # virtual_lines = true;
      # Only show virtual line diagnostics for the current cursor line
      # virtual_lines.current_line = true;
    };

    # [[ Basic Keymaps ]]
    #  See `:help vim.keymap.set()`
    keymaps = [
      # Clear highlights on search when pressing <Esc> in normal mode
      (map [ "<Esc>"  "<cmd>nohlsearch<CR>"  "Clear highlights on search"      ])
      # Disable arrow keys in normal mode
      # (map [ "<left>"   "<cmd>echo 'Use h to move!!'<CR>"  ])
      # (map [ "<right>"  "<cmd>echo 'Use l to move!!'<CR>"  ])
      # (map [ "<up>"     "<cmd>echo 'Use k to move!!'<CR>"  ])
      # (map [ "<down>"   "<cmd>echo 'Use j to move!!'<CR>"  ])

      # Keybinds to make split navigation easier.
      #  Use CTRL+<hjkl> to switch between windows
      #
      #  See `:help wincmd` for a list of all window commands
      # (map [ "<C-h>"  "<C-w><C-h>"  "Move focus to the left window"   ])
      # (map [ "<C-l>"  "<C-w><C-l>"  "Move focus to the right window"  ])
      # (map [ "<C-j>"  "<C-w><C-j>"  "Move focus to the lower window"  ])
      # (map [ "<C-k>"  "<C-w><C-k>"  "Move focus to the upper window"  ])

      # exit insert mode without <Esc> (https://github.com/omerxx/dotfiles/blob/c52df4/nvim/lua/config/keymaps.lua)
      # (map [ "jj"  "<Esc>"  "Exit insert mode"  "i" { noremap = true; silent = true; } ])
      # (map [ "jk"  "<Esc>"  "Exit insert mode"  "i" { noremap = true; silent = true; } ])

      # for convenience:
      (map [ "<C-s>"       "<Esc><Cmd>w<CR>"   "Save file"  [ "n" "i" ]  { noremap = true; silent = true; }  ])
      (map [ "<C-s><C-s>"  "<Esc><Cmd>wa<CR>"  "Save all"   [ "n" "i" ]  { noremap = true; silent = true; }  ])
      (map [ "<m-q>"       "<Cmd>qa<CR>"       "Quit"       [ "n" "i" ]  { noremap = true; silent = true; }  ])
    ];

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    autoCmd = [
      # Highlight when yanking (copying) text
      #  See `:help vim.hl.on_yank()`
      {
        event = [ "TextYankPost" ];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.hl.on_yank()
          end
        '';
      }
    ];

    plugins = {
      # Adds icons for plugins to utilize in ui
      web-devicons.enable = config.programs.nixvim.globals.have_nerd_font;

      # Detect tabstop and shiftwidth automatically
      # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
      sleuth = {
        enable = true;
      };
    };

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
