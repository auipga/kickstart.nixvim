{
  programs.nixvim = {
    # Custom treesitter queries for Home Manager nix files
    # https://github.com/calops/hmts.nvim
    # https://nix-community.github.io/nixvim/plugins/hmts/index.html
    plugins.hmts.enable = true;
  };
}
