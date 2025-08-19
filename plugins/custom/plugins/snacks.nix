{
  programs.nixvim = {
    plugins.snacks = {
      # https://github.com/folke/snacks.nvim
      # https://nix-community.github.io/nixvim/plugins/snacks/settings/index.html
      enable = true;
      settings = {
        notifier = {
          # https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
          timeout = 5000;
          margin.top = 1;
          style = "fancy"; # compact*|fancy|minimal
        };
        picker = {
          # https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
          # enabled = true;
          # ui_select = true;
        };
        # enabled by default:
        # - bigfile
        # - notifier
        # - quickfile
        # - statuscolumn
        # - words
      };
      # TODO: do more configuration, add keymaps to the tools
      # see https://github.com/folke/snacks.nvim/?tab=readme-ov-file#-usage
    };
  };
}
