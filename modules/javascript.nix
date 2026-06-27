# modules/javascript.nix
{ pkgs, ... }:
{
  programs.nixvim = {
    # plugins.dap.enable = true;
    # plugins.dap-ui.enable = true;
    plugins.lsp.enable = true;

    plugins.lsp.servers.ts_ls.enable = true;

    plugins.treesitter = {
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        json
        javascript
        typescript
      ];
    };
  };
}
