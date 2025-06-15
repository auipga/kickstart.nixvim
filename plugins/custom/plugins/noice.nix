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
        lsp_doc_border = !false; # add a border to hover docs and signature help
      };
    };

    # Optional dependencies:
    # plugins.nui.enable = true;
    # plugins.notify.enable = true;
    # plugins.telescope.enable = true;
    # plugins.cmp.enable = true;
    # plugins.lsp.enable = true;
  };
}
