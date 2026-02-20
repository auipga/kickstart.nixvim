{ pkgs, ... }:
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # A neovim plugin that lets you easily create Telescope pickers from arbitrary console commands
    # https://github.com/axkirillov/easypick.nvim
    extraPlugins = with pkgs; [
      (vimUtils.buildVimPlugin {
        pname = "easypick";
        version = "0.6.0"; # Apr 26, 2025
        src = fetchFromGitHub {
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

          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff()
          },
        },
      })
    '';

    keymaps = [
      (kmap [ "<leader>se"  "<cmd>Easypick<cr>"            "[S]earch [E]asypick"      ])
      (kmap [ "<leader>el"  "<cmd>Easypick ls<cr>"         "[E]asypick [l]s"          ])
      (kmap [ "<leader>ec"  "<cmd>Easypick conflicts<cr>"  "[E]asypick [c]onflicts"   ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>e";
        group = "[E]asypick";
      }
    ];
  };
}
