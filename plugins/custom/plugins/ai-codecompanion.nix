{ pkgs, ... } :
let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "AI: "; extraOpts = { noremap = true; }; };
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
          { name = "vectorcode"; opts = { top_k = 15; }; }
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
      (mapP [ "<leader>aa"  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"                       ])
      (mapP [ "<C-a>"       "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"          [ "n" "i" ]  ])
      (mapP [ "<leader>aa"  "<cmd>CodeCompanionChat Add<cr>"      "[A]dd selection to Chat"  [ "v" ]  ])
      (mapP [ "<C-a>"       "<cmd>CodeCompanionChat Add<cr>"      "[A]dd selection to Chat"  [ "v" ]  ])
      (mapP [ "<leader>an"  "<cmd>CodeCompanionChat<cr>"          "[N]ew Chat"                        ])
      (mapP [ "<leader>ae"  "<cmd>CodeCompanion<cr>"              "Inline [e]dit"                     ])
      (mapP [ "<leader>aA"  "<cmd>CodeCompanionActions<cr>"       "[A]ctions"                         ])
      (mapP [ "<leader>ac"  "<cmd>CodeCompanionCmd<cr>"           "[C]md"                             ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>a";
        group = "AI";
      }
    ];
  };
}
