let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html?highlight=neo-tree#pluginsneo-treepackage
    plugins.neo-tree = {
      enable = true;

      filesystem = {
        window = {
          mappings = {
            "\\" = "close_window";
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      (map [ "\\"  "<cmd>Neotree reveal<cr>"  "NeoTree reveal"  ])
    ];
  };
}
