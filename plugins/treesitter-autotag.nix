# plugins/treesitter-autotag.nix
{
  programs.nixvim = {
    # Auto close and auto rename html tag (using treesitter)
    # https://github.com/windwp/nvim-ts-autotag
    # https://nix-community.github.io/nixvim/plugins/ts-autotag/index.html
    plugins.ts-autotag.enable = true;
  };
}
