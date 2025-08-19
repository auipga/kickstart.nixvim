{
  programs.nixvim = {
    # https://github.com/MeanderingProgrammer/render-markdown.nvim/
    # https://nix-community.github.io/nixvim/plugins/render-markdown/index.html
    plugins.render-markdown.enable = true;
    plugins.render-markdown.settings = {
      file_types = [
        "markdown" # default
        "codecompanion"
        # TODO: use lib.mkAfter in ./ai-codecompanion.nix
        # right now this won't work as it 'replaces' it and 'needs' lib.mkDefault and mkForce
      ];

      # silence warning 'parser not installed'
      latex.enabled = false;
    };
  };
}
