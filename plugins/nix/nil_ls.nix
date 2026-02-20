{
  programs.nixvim = {
    # https://github.com/oxalica/nil
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt#nil_ls
    # https://nix-community.github.io/nixvim/plugins/lsp/servers/nil_ls/index.html
    plugins.lsp.servers.nil_ls.enable = false;
    plugins.lsp.servers.nil_ls = {
      settings = {
        nil = {
          formatting.command = [ "nixfmt" ]; # default: "nixpkgs-fmt"
          # nixpkgs = {
          #   # Ensures Nixpkgs schema support (autocomplete for `programs.` and others)
          #   useRegistry = true;
          #   registry = { nixpkgs = "nixpkgs"; };
          # };
        };
        rootPatterns = [ "flake.nix" ];
      };
    };
  };
}
