{
  programs.nixvim = {
    # https://github.com/folke/noice.nvim
    # https://nix-community.github.io/nixvim/plugins/noice/index.html
    plugins.noice.enable = true;
    plugins.noice.settings = {
      # Suggested setup
      presets = {
        bottom_search = true; # default: false;
        command_palette = true; # default: false;
        inc_rename = true; # default: false;
        long_message_to_split = true; # default: false;
        lsp_doc_border = true; # default: false;
      };
    };
  };
}
