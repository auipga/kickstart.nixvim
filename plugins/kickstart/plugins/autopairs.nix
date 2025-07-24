{
  # Inserts matching pairs of parens, brackets, etc.
  # https://github.com/windwp/nvim-autopairs
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;
    };

    # If you want to automatically add `(` after selecting a function or method
    extraConfigLua = ''
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
    '';
  };
}
