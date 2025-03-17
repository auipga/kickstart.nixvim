{
  programs.nixvim = {
    # https://github.com/epwalsh/obsidian.nvim/
    # https://nix-community.github.io/nixvim/plugins/obsidian/index.html
    plugins.obsidian.enable = true;
    plugins.obsidian.settings.workspaces = [
      # TODO: define your workspaces here
    ];

    opts.conceallevel = 1;
  };
}
