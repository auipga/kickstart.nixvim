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
          show_defaults = false; # default: true; show all available adapters?
          show_model_choices = true; # default: true; show all available model choices for the selected adapter?
        };
        openai_ccc.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai", {
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
        gemini_ccc.__raw = ''
          function()
            return require("codecompanion.adapters").extend("gemini", {
              env = { api_key = vim.env.GEMINI_API_KEY },
              schema = {
                model       = { default = "gemini-2.5-pro" },
                max_tokens  = { default = 2048 },
                temperature = { default = 0.2 },
                top_p       = { default = 0.95 },
                reasoning_effort = { default = "medium" }, -- high|medium*|low|none
              },
            })
          end
        '';
        gemini.__raw = ''
          function()
            return require("codecompanion.adapters").extend("gemini", {
              env = { api_key = "" },
              schema = {
                model       = { default = "gemini-2.5-flash" },
                max_tokens  = { default = 2048 },
                temperature = { default = 0.2 },
                top_p       = { default = 0.95 },
                reasoning_effort = { default = "medium" }, -- high|medium*|low|none
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
          provider = "default";
        };
        chat = {
          window = {
            layout = "vertical";
            opts = {
              cursorline = true; # default: false
            };
          };
          auto_scroll = false; # default: true
          intro_message = ""; # default: "Welcome to CodeCompanion ✨! Press ? for options"
        };
      };

      strategies = {
        chat = {
          adapter = "openai_ccc";
          roles.llm.__raw = ''function(adapter) return adapter.formatted_name end'';
          opts = {
            completion_provider = "blink"; # blink*|cmp|coc|default
          };
        };
        inline = {
          adapter = "openai_ccc";
        };
#        agent = {
#          adapter = "openai_gpt4o"; # optional
#        };
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
