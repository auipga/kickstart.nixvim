{
  programs.nixvim = {
    # Integrate VectorCode into CodeCompanion
    # https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#olimorriscodecompanionnvim

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode = {
        enabled = true;
        opts = {
          add_tool = true; # the @vectorcode tool becomes available in the CodeCompanion chat buffer
          add_slash_command = true; # the /vectorcode slash command
          tool_group = {
            enabled = true;
            collapse = true;
            # tools in this array will be included to the `vectorcode_toolbox` tool group
            extras = {};
          };
          tool_opts = {
            ls = {};
            query = {};
            vectorise = {};
          };
        };
      };

#      TODO: make this work
#      context.providers = [ ] ++ [
#        { name = "vectorcode"; opts = { top_k = 15; }; }
#      ];
    };
  };
}
