# plugins/lualine.nix
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
        # "neo-tree"       # see ./neo-tree.nix
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
            -- show indicator while recording a macro
            {
              function()
                local rec = vim.fn.reg_recording()
                if rec ~= "" then
                  return "REC @" .. rec
                end

                return ""
              end,
              cond = function()
                return vim.fn.reg_recording() ~= ""
              end,
              color = { fg = "#ffa064" },
            },

            -- ./auto-session.nix
            function()
              return require("auto-session.lib").current_session_name(true):gsub("branch: ", "")
            end,

            -- ./vectorcode.nix
            -- see https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md#status-line-component
            -- function()
            --   return require("vectorcode.integrations").lualine({
            --     show_job_count = true, -- default: false
            --   })
            -- end,

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
