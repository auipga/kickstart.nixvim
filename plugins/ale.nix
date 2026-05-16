# plugins/ale.nix
{ pkgs, ... }:
{
  programs.nixvim = {
    # Asynchronous Lint Engine
    # - Linting, Fixing, Completion, Go To Definition, Find References,
    #   Hovering, Symbol Search, Refactoring: Rename, Actions
    # https://github.com/dense-analysis/ale
    extraPlugins = with pkgs; [
      vimPlugins.ale
    ];
    /*
      TODO: create keymaps
      ALEGoToDefinition
      ALEFindReferences
      ALEHover
      ALESymbolSearch
      TODO: configure
    */
    extraConfigLuaPre = ''

    '';
  };
}
