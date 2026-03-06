{
  imports = [
    # Install mcp-hub and mcphub-nvim
    ../../mcp-hub.nix
  ];

  programs.nixvim = {
    # Requirements
    plugins.codecompanion.enable = true;

    plugins.codecompanion.settings = {
      # Configure the extension
      # https://ravitemer.github.io/mcphub.nvim/extensions/codecompanion.html#mcp-hub-extension
      extensions.mcphub = {
        callback = "mcphub.extensions.codecompanion";
        opts = {
          #### MCP Tools
          # Make individual tools (@server__tool) and server groups (@server) from MCP servers
          make_tools = true; # default: true
          # Show individual tools in chat completion (when make_tools=true)
          show_server_tools_in_chat = true; # default: true
          # Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          add_mcp_prefix_to_tool_names = true; # default: false
          # Show tool results directly in chat buffer
          show_result_in_chat = true; # default: true
          # function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string
          # Function to format tool names to show in the chat buffer
          # format_tool = null;

          #### MCP Resources
          # Convert MCP resources to #variables for prompts
          make_vars = false; # default: true
          # enable again once this is merged: https://github.com/ravitemer/mcphub.nvim/pull/279

          #### MCP Prompts
          # Add MCP prompts as /slash commands
          make_slash_commands = true; # default: true
        };
      };
    };
  };
}
