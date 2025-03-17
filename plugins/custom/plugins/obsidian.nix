{
  programs.nixvim = {
    # https://github.com/epwalsh/obsidian.nvim/
    # https://nix-community.github.io/nixvim/plugins/obsidian/index.html
    plugins.obsidian.enable = true;
    plugins.obsidian.settings.workspaces = [
      {
        name = "start";
        path = "~/Documents/obsidian/start";
      }
    ];

    opts.conceallevel = 1;
  };
}
