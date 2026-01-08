{
  programs.nixvim = {
    # https://github.com/nvim-lualine/lualine.nvim
    # https://nix-community.github.io/nixvim/plugins/lualine/settings/index.html
    plugins.lualine.enable = true;
    plugins.lualine.settings = {
      options.theme = "auto";
      extensions = [
        # "aerial"
        # "assistant"
        # "avante"
        # "chadtree"
        # "ctrlspace"
        # "fern"
        # "fugitive"
        # "fzf"
        # "lazy"
        # "man"
        # "mason"
        # "mundo"
        # "neo-tree"       # see ../../kickstart/plugins/neo-tree.nix
        # "nerdtree"
        # "nvim-dap-ui"
        # "nvim-tree"
        # "oil"
        # "overseer"
        "quickfix"
        # "symbols-outline"
        # "toggleterm"      # see ./terminal.nix
        # "trouble"         # see ./trouble.nix
      ];
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x.__raw = ''
          {
            -- ./noice.nix
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#0f9e64" },
            },

            -- ./auto-session.nix
            function()
              return require("auto-session.lib").current_session_name(true)
            end,

            -- ./ai-vectorcode.nix
            -- TODO: make vectorcode lualine work
            -- see https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md#status-line-component
            -- require("vectorcode.integrations").lualine({
            --   show_job_count = true, -- default: false
            -- }),

            "lsp_status",
            -- "encoding",
            -- "fileformat",
            "filetype",
          }
        '';
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactive_sections = {
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
      };
    };
  };
}
