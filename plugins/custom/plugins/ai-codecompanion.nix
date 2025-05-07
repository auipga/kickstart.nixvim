{ pkgs, ... } :
let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "[C]odecompanion: "; extraOpts = { noremap = true; silent = true; }; };
in
{
  programs.nixvim = {
    # AI-powered coding, seamlessly in Neovim
    # https://github.com/olimorris/codecompanion.nvim/
    # https://nix-community.github.io/nixvim/plugins/codecompanion/index.html
    plugins.codecompanion.enable = true;

    # Optional but recommended runtime deps:
    plugins.treesitter.enable = true;
    plugins.telescope.enable = true; # for slash-command pickers
    plugins.cmp.enable = true; # if you’d like to complete slash commands
    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim # async helpers
    ];

    plugins.cmp.settings.sources = [
      { name = "codecompanion"; }
    ];

    plugins.codecompanion.settings = {
      adapters = {
        opts = {
        };
        openai_gpt4o.__raw = ''
          function()
            local adapters = require("codecompanion.adapters")
            return adapters.extend("openai", {
              env = { api_key = vim.env.OPENAI_API_KEY or "cmd:pass show openai/api-key" },
              schema = {
                model       = { default = "gpt-4o" },
                max_tokens  = { default = 2048 },
                temperature = { default = 0.2 },
                top_p       = { default = 0.95 },
              },
            })
          end
        '';
      };

      context = {
        providers = [
            { name = "git_diff"; opts = { max_lines = 400; }; }
            { name = "lsp";      opts = { diagnostics = true; definition = true; }; }
        ];
      };

      display = {
        chat = {
          window = {
            layout = "float";
          };
        };
      };

      strategies = {
        chat = {
          adapter = "openai_gpt4o";
        };
        inline = {
          adapter = "openai_gpt4o";
        };
      };
    };

   keymaps = [
      (mapP [ "<leader>cc" "<cmd>CodeCompanionChat Toggle<cr>"   "[C]hat window"          [ "n" "v" ]      ])
      (mapP [ "<leader>ce" "<cmd>CodeCompanion<cr>"              "Inline [e]dit with AI"  [ "n" "v" ]      ])
    ];
  };
}
