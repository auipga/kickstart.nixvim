# plugins/mcp-hub.nix
{ lib, pkgs, mcp-hub, ... } :
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  # A centralized manager for Model Context Protocol (MCP) servers with dynamic server management and monitoring
  # https://github.com/ravitemer/mcp-hub
  home.packages = [ mcp-hub ];

  programs.nixvim = {
    # An MCP client that seamlessly integrates MCP servers into your editing workflow
    # https://github.com/ravitemer/mcphub.nvim
    extraPlugins = with pkgs.vimPlugins; [ mcphub-nvim ];

    # Configuration
    plugins.codecompanion.luaConfig.pre = lib.mkAfter ''
      require("mcphub").setup({
        port = 3000,
        config = vim.fn.expand("~/mcp-hub/mcp-servers.json"),
        cmd = "${mcp-hub}/bin/mcp-hub"
      })
    '';

    keymaps = [
      (kmap [ "<leader>m" "<cmd>MCPHub<CR>" ])
    ];
  };
}
