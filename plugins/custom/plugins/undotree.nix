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
      {
        mode = "n";
        key = "<leader><F5>";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          desc = "Toggle Undotree";
        };
      }
    ];
  };
}
