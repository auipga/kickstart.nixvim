{ lib, ... }:
let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/mbbill/undotree/
    # https://nix-community.github.io/nixvim/plugins/undotree.html
    plugins.undotree.enable = true;
    plugins.undotree = {
      settings = {
        ShortIndicators = true; # default: 0
        WindowLayout = 2; # default: 1
        # SplitWidth = 40; # default: 30 or 24 (with ShortIndicators)
        # DiffpanelHeight = 20; # default: 10
        SetFocusWhenToggle = true; # default 0
        DiffCommand = "diff"; # default: diff
      };
    };

    keymaps = [
      (map [ "<leader>tu"  "<cmd>UndotreeToggle<CR>"  "[T]oggle [U]ndotree"  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      options.ignore_focus = lib.mkAfter [
        "undotree"
        "diff"
      ];
    };
  };
}
