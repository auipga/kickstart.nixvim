{
  programs.nixvim = {
    # https://github.com/tpope/vim-repeat/
    # https://nix-community.github.io/nixvim/plugins/repeat.html
    # The following plugins support repeat.vim:
    # - surround.vim
    # - speeddating.vim
    # - unimpaired.vim
    # - vim-easyclip
    # - vim-radical
    plugins.repeat.enable = true;
  };
}
