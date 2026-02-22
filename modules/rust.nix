{ lib, pkgs, ... }:
{
  programs.nixvim = {
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;
    plugins.dap-lldb.enable = true;
    plugins.lsp.enable = true;

    plugins.lsp.servers = {
      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };

      # https://github.com/crisidev/bacon-ls
      # https://nix-community.github.io/nixvim/plugins/lsp/servers/bacon_ls/index.html
      # bacon_ls.enable = true;
      # bacon_ls.package = ...;
    };

    plugins.treesitter = {
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        rust
        toml
      ];
    };

    plugins.crates.enable = true;

    plugins.cmp.settings.sources = lib.mkAfter [
      { name = "crates"; }
    ];
  };
}
