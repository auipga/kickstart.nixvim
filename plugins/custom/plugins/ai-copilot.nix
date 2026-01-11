{
  programs.nixvim = {
    plugins.copilot-lua.enable = !true; # preferable over official copilot-vim
    # setup:
    # :Copilot auth
    #
    plugins.copilot-lua.settings = {
      filetypes = {
        nix = true;
        sh.__raw = ''
          function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              -- disable for .env files
              return false
            end
            return true
          end
        '';

      };
    };

    # https://nix-community.github.io/nixvim/plugins/lsp/servers/copilot/index.html
    # plugins.lsp.servers.copilot.enable = true;

    # plugins.copilot-cmp.enable = true; # 22 KiB

    # https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#copilotc-nvimcopilotchatnvim
    # plugins.copilot-chat.enable = true; # 367 KiB

    # plugins.blink-cmp.enable = true; # 5.1 MiB

    # plugins.blink-cmp-copilot.enable = true; # 88.7 KiB

    # plugins.blink-copilot.enable = true; # 24.0 KiB
  };
}
