let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    plugins.undotree.enable = true;
    plugins.undotree = {
      settings = {
        ShortIndicators = true; # default: 0
        WindowLayout = 3; # default: 1
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      (map [ "<leader><F5>"  "<cmd>UndotreeToggle<CR>"  "Toggle Undotree"  ])
    ];
  };
}
