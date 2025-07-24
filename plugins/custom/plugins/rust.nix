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
