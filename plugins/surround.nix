# plugins/surround.nix
{
  programs.nixvim = {
    # Delete/change/add parentheses/quotes/XML-tags/... with ease
    # https://github.com/tpope/vim-surround/
    # https://nix-community.github.io/nixvim/plugins/vim-surround/index.html
    plugins.vim-surround.enable = true;
    # is repeatable through ./repeat.nix
    # replaces mini.surround ./mini.nix
  };
}
