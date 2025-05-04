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

      easypick.setup({
        pickers = {
          -- add your custom pickers here
        },
      })
    '';
  };
}
