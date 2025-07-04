{ pkgs, ... } :
let
  map = import ../../../lib/mkKeymap.nix { };
  mapP = import ../../../lib/mkKeymap.nix { prefix = "AI: "; extraOpts = { noremap = true; }; };
in
{
  programs.nixvim = {
    # A history management extension for codecompanion AI chat plugin
    # that enables saving, browsing and restoring chat sessions.
    # https://github.com/ravitemer/codecompanion-history.nvim
    extraPlugins = [
      pkgs.vimPlugins.codecompanion-history-nvim
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
      auto_generate_title = true; # default: true;
      # On exiting and entering neovim, loads the last chat on opening chat
      continue_last_chat = true; # default: false;
      # When chat is cleared with `gx` delete the chat from history
      delete_on_clearing_chat = false;
      # Picker interface ("telescope"; "snacks" or "default")
      picker = "snacks";
      # Enable detailed logging for history extension
      enable_logging = false;
      # Directory path to save the chats
      dir_to_save.__raw = "vim.fn.stdpath('data') .. '/codecompanion-history'";
    };

    keymaps = [
     (mapP [ "<leader>ah"  "<cmd>CodeCompanionHistory<cr>"  "[H]istory"  ])
    ];
  };
}
