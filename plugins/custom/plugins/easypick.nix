{ pkgs, ... }:
{
  programs.nixvim = {
    # A neovim plugin that lets you easily create Telescope pickers from arbitrary console commands
    # https://github.com/axkirillov/easypick.nvim
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "easypick";
        version = "0.6.0"; # Apr 26, 2025
        src = pkgs.fetchFromGitHub {
          owner = "axkirillov";
          repo = "easypick.nvim";
          rev = "e623b38a0d8fb96446dd8dd3f38ccb545e1810a8";
          sha256 = "sha256-gIx5yOwqPyg6hySiJPf1dtt250qFDBVa8pkjpncf0V8=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
    ];

    # dependencies
    plugins.telescope.enable = true; # required

    # configuration with lua
    plugins.telescope.luaConfig.pre = ''
      local easypick = require("easypick")

      -- only required for the example to work
      local get_default_branch = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
      local base_branch = vim.fn.system(get_default_branch) or "main"

      easypick.setup({
        pickers = {
          -- add your custom pickers here
          -- below you can find some examples of what those can look like

          -- list files inside current folder with default previewer
          {
            -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
            name = "ls",
            -- the command to execute, output has to be a list of plain text entries
            command = "ls",
            -- specify your custom previwer, or use one of the easypick.previewers
            previewer = easypick.previewers.default()
          },

          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff({base_branch = base_branch})
          },

          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff()
          },
        },
      })
    '';
  };
}
