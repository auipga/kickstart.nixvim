let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
    plugins.treesitter-context = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      (map [ "<leader>tc"  "<cmd>TSContextToggle<CR>"  "Toggle Context"  ])
    ];
  };
}
