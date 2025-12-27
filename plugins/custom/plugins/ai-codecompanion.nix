{ lib, pkgs, ... } :
let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "CodeCompanion "; extraOpts = { noremap = true; silent = true; }; };
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

    plugins.cmp.settings.sources = [
      { name = "codecompanion"; }
    ];

    plugins.codecompanion.settings = {
      adapters.acp.opts.show_presets = false;
      adapters.http = {
        rules = {
          opts = {
            chat = {
              enabled = true; # Automatically add memory to new chat buffers?
            };
          };
        };

        opts = {
          show_presets = false; # default: true; show all available adapters?
          show_model_choices = true; # default: true; show all available model choices for the selected adapter?
        };
        # TODO: use GPG instead env var (https://github.com/olimorris/codecompanion.nvim/discussions/601)
        # TODO: use pass?
        openai.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai", {
              env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/work/OPENAI" },
              schema = {
                model       = { default = "gpt-5" },
                max_tokens  = { default = 2048 },
                temperature = { default = 0.2 },
                top_p       = { default = 0.95 },
              },
            })
          end
        '';
        gemini.__raw = ''
          function()
            return require("codecompanion.adapters").extend("gemini", {
              env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/work/GEMINI" },
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
          opts = {
            show_preset_actions = true; # Show the default actions in the action palette?
            show_preset_prompts = true; # Show the default prompt library in the action palette?
          };
        };
        chat = {
          window = {
            layout = "vertical"; # float|vertical*|horizontal|buffer
            opts = {
              cursorline = true; # default: false
            };
          };
          auto_scroll = false; # default: true
          # intro_message = ""; # default: "Welcome to CodeCompanion ✨! Press ? for options"
          show_settings = false; # Show LLM settings at the top of the chat buffer?
          start_in_insert_mode = false; # Open the chat buffer in insert mode?
        };
        diff = {
          enabled = true;
          close_chat_at = 200; # default: 240, Close an open chat buffer if the total columns of your display are less than...
          # layout = "vertical"; # vertical*|horizontal split for default provider
          inline.layout = "float"; # default: non_float
          # opts = [ "internal" "filler" "closeoff" "algorithm:patience" "followwrap" "linematch:120" ];
          # provider = "default"; # default*|mini_diff
        };
      };

      interactions = {
        chat = {
          adapter = "openai";
          roles.llm.__raw = ''function(adapter) return adapter.formatted_name end'';
          opts = {
            # system_prompt = ""; moved here
            completion_provider = "cmp"; # blink*|cmp|coc|default
          };
          keymaps = {
            send.modes.i = [ "<C-CR>" "<C-s>" ];
            # regenerate.modes.n = "g,"; # default: gr (overlaps gr_ for lsp stuff)
            # codeblock.modes.n = "gC"; # default: gc (overlaps gcc for 'toggle comment')
            # auto_tool_mode.modes.n = "g."; # default: gta (overlaps gt for 'next tab')
          };
        };
        inline = {
          adapter = {
            name = "openai";
            # model = "";
          };
          keymaps = {
            # accept_change.modes.n = ""; # default: ga
            # reject_change.modes.n = ""; # default: gr
          };
        };
        cmd = {
          adapter = {
            name = "openai";
            # model = "";
          };
        };
      };

/*
      prompt_library = import ./ai-codecompanion-prompts.nix;
*/
    };

    # Suggested Plugin Workflow
    # https://codecompanion.olimorris.dev/getting-started.html#suggested-plugin-workflow
    # Expand 'cc' into 'CodeCompanion' in the command line
    extraConfigLua = "vim.cmd([[cab cc CodeCompanion]])";
    keymaps = [
      (mapP [ "<leader>."  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" ]  ])
      (mapP [ "<M-.>"      "<cmd>CodeCompanionActions<cr>"       "Actions"            [ "n" "v" "i" ]  ])
      (mapP [ "ga"         "<cmd>CodeCompanionChat Add<cr>"      "Add selection to Chat"  [ "v" ]  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      options.ignore_focus = lib.mkAfter [ "codecompanion" ];
    };
    plugins.render-markdown.settings = {
      # Replace tags with icons:
      html.tag = {
        file = {
          icon = "󰈙 ";
          highlight = "Normal";
        };
        tool = {
          icon = " ";
          highlight = "Normal";
        };
        buf = {
          icon = " ";
          highlight = "Normal";
        };
      };
    };
  };
}
