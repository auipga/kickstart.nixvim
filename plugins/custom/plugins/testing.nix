{
  programs.nixvim = {
    # plugins.___.enable = true;
    /*
      dashboard
      lsp-*

      https://nix-community.github.io/nixvim/plugins/copilot-chat/index.html
      Copilot Chat, cmp, lua, vim
    */

    plugins.vim-be-good.enable = true;
    #    plugins.alpha = {
    #      enable = true;
    #      theme = "dashboard";
    #    };
  };
}
