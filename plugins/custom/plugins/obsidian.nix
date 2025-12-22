{
  programs.nixvim = {
    # https://github.com/epwalsh/obsidian.nvim/
    # https://nix-community.github.io/nixvim/plugins/obsidian/index.html
    plugins.obsidian.enable = true;
    plugins.obsidian.settings = {
      legacy_commands = false; # remove old :ObsidianBacklinks, use :Obsidian backlinks, silence message about it
      ui.enable = false;
      workspaces = [
        {
          name = "start";
          path = "~/Documents/obsidian/start";
        }
      ];
    };

    opts.conceallevel = 1;
  };
}
