# modules/php.nix
{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;
    plugins.lsp.enable = true;

    plugins.lsp.servers = {
      phpactor = {
        enable = true;
      };
    };

    plugins.treesitter = {
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        php
        php_only
        phpdoc
      ];
    };
  };
}
