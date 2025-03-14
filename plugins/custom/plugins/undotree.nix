{
  programs.nixvim = {
    plugins.undotree.enable = true;

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
