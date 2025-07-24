{
  programs.nixvim = {
    # Add indentation guides even on blank lines
    # For configuration see `:help ibl`
    # https://github.com/lukas-reineke/indent-blankline.nvim/
    # https://nix-community.github.io/nixvim/plugins/indent-blankline/index.html
    plugins.indent-blankline = {
      enable = true;
    };
  };
}
