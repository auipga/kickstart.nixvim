let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # Show code context
    # https://github.com/nvim-treesitter/nvim-treesitter-context/
    # https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
    plugins.treesitter-context = {
      enable = true;
      settings = {
        enable = false; # default: true
        mode = "cursor"; # cursor*|topline
      };
    };

    keymaps = [
      (map [ "<leader>tc"  "<cmd>TSContext toggle<CR>"  "[T]oggle [C]ontext"  ])
    ];
  };
}
