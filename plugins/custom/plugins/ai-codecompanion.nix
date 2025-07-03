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
#          show_defaults = false;
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
        action_palette = {
#           provider = "telescope";
#           provider = "mini_pick";
#           provider = "snacks"; # broken
        };
        chat = {
          window = {
            layout = "vertical";
          };
        };
      };

      # prompt_library = {};

      # UI tweaks: cost widget
      # TODO: key cost does not exist! find another way to apply this.
#      cost = {
#        enable = true;
#        position = "statusline";
#      };

      strategies = {
        chat = {
          adapter = "openai_gpt4o";
#          tools = {
#            vectorcode = {
#              description = "Run VectorCode to retrieve the project context.";
#              callback.__raw = "require('vectorcode.integrations').codecompanion.chat.make_tool({})";
#            };
#          };

          ## User Interface (UI)
          # User and LLM Roles
          roles = {
            # The header name for the LLM's messages
            # @type string|fun(adapter: CodeCompanion.Adapter): string
            llm.__raw = ''function(adapter)
              return "CodeCompanion - (" .. adapter.formatted_name .. ")"
            end
            '';
            # The header name for your messages
            # @type string
            user = "Me";
          };
          opts = {
            completion_provider = "blink"; # blink*|cmp|coc|default
          };
          auto_scroll = false;

          # Additional Options
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options";
          show_header_separator = false; # Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = "─"; # The separator between the different messages in the chat buffer
          show_references = true; # Show references (from slash commands and variables) in the chat buffer?
          show_settings = false; # Show LLM settings at the top of the chat buffer?
          show_token_count = true; # Show the token count for each response?
          start_in_insert_mode = false; # Open the chat buffer in insert mode?
        };
        inline = {
          adapter = "openai_gpt4o";
        };
#        agent = {
#          adapter = "openai_gpt4o"; # optional
#        };
      };

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

    keymaps = [
      (mapP [ "<leader>aa"  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"                       ])
      (mapP [ "<C-a>"       "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"      [ "n" "i" "t" ]  ])
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
        mode = [ "n" "v" ];
      }
    ];
  };
}
