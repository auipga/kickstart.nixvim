{
  programs.nixvim = {
    # https://github.com/figsoda/nix-develop.nvim
    # https://nix-community.github.io/nixvim/plugins/nix-develop/index.html
    plugins.nix-develop.enable = true;

    # https://github.com/LnL7/vim-nix/
    # https://nix-community.github.io/nixvim/plugins/nix.html
    plugins.nix.enable = true;

    # https://github.com/oxalica/nil
    # https://nix-community.github.io/nixvim/plugins/lsp/servers/nil_ls/index.html
    plugins.lsp.servers.nil_ls.enable = true;
  };
}
