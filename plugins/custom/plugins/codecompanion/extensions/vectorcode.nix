{ pkgs, ... }:
{
  imports = [
    ../../vectorcode.nix
  ];

  programs.nixvim = {
    # Integrate VectorCode into CodeCompanion
    # https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md#olimorriscodecompanionnvim

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode.enabled = true;
      extensions.vectorcode.opts.prompt_library = {
        # https://github.com/olimorris/codecompanion.nvim/discussions/2085
        "CodeCompanion Assistant" = {
          project_root = pkgs.vimPlugins.codecompanion-nvim;
          file_patterns = [
            "lua/codecompanion/**.lua"
            "doc/**/*.md"
          ];
        };
      };
      # TODO: use this for mcp, surrealdb and all others too

      # Setup: add to context.providers in ../default.nix
      # { name = "vectorcode"; opts = { top_k = 15; }; }
    };
  };
}
