# see home-manager/modules/coding/lazygit.nix
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/kdheepak/lazygit.nvim
    # https://nix-community.github.io/nixvim/plugins/lazygit/index.html
    plugins.lazygit.enable = true;

    keymaps = [
      (kmap [ "<m-g>"       "<cmd>LazyGitCurrentFile<CR>"  "LazyGitCurrentFile"  ])
    ];
  };
}
