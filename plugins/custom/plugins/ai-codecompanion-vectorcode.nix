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

      hooks = {
        on_pre_send.__raw = ''
          function(payload)
            if payload.dollar_cost and payload.dollar_cost > 1.00 then
              vim.notify("Request aborted: cost ≥ $1", vim.log.levels.WARN)
              return false   -- cancel
            end
          end,
        '';
      };
    };
  };
}
