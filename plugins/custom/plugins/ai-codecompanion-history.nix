{ pkgs, ... } :
let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "[C]odecompanion: "; extraOpts = { noremap = true; silent = true; }; };
in
{
  programs.nixvim = {
    # A history management extension for codecompanion AI chat plugin
    # that enables saving, browsing and restoring chat sessions.
    # https://github.com/ravitemer/codecompanion-history.nvim
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "codecompanion-history";
        version = "dev-2025-05-07";
        src = pkgs.fetchFromGitHub {
          owner = "ravitemer";
          repo = "codecompanion-history.nvim";
          rev = "629bdfd846709babe1a7674858c00dd3af48c281";
          sha256 = "sha256-ma2nkG+fCfVGkokfu6L7L9arqJ2RfC6T+HeVuzBmg1w=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
    ];

    # Requirements
    plugins.codecompanion.enable = true;
    plugins.telescope.enable = true; # optional, for enhanced picker
    plugins.snacks.enable = true; # optional, for enhanced picker

    # Configure the extension
    plugins.codecompanion.settings.extensions.history.enabled = true;
    plugins.codecompanion.settings.extensions.history.opts = {
      # Keymap to open history from chat buffer
      keymap = "gh";
      # Automatically generate titles for new chats
      auto_generate_title = false; # default: true;
      # On exiting and entering neovim, loads the last chat on opening chat
      continue_last_chat = true; # default: false;
      # When chat is cleared with `gx` delete the chat from history
      delete_on_clearing_chat = false;
      # Picker interface ("telescope"; "snacks" or "default")
      picker = "telescope";
      # Enable detailed logging for history extension
      enable_logging = true; # default: false;
      # Directory path to save the chats
      dir_to_save.__raw = "vim.fn.stdpath('data') .. '/codecompanion-history'";
    };

    keymaps = [
     (mapP [ "<leader>ch"  "<cmd>CodeCompanionHistory<cr>"  "[H]istory"  ])
    ];
  };
}
