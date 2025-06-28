{
  programs.nixvim = {
    # Integrate VectorCode into CodeCompanion
    # https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#olimorriscodecompanionnvim
    # https://github.com/olimorris/codecompanion.nvim/blob/main/doc/extensions/vectorcode.md

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode = {
        enabled = true;
        opts = {
          add_tool = true; # the @vectorcode tool becomes available in the CodeCompanion chat buffer
          add_slash_command = true; # the /vectorcode slash command
          tool_opts = {};
        };
      };

#      TODO: make this work
#      context.providers = [ ] ++ [
#        { name = "vectorcode"; opts = { top_k = 15; }; }
#      ];
    };
  };
}
