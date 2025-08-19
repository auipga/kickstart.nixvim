{
  programs.nixvim = {
    # https://github.com/MeanderingProgrammer/render-markdown.nvim/
    # https://nix-community.github.io/nixvim/plugins/render-markdown/index.html
    plugins.render-markdown.enable = true;
    plugins.render-markdown.settings = {
      # silence warning 'parser not installed'
      latex.enabled = false;
    };
  };
}
