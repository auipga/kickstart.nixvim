{ lib, ... }:
let
  mapP = import ../../../../lib/mkKeymap.nix { prefix = "CodeCompanion "; extraOpts = { noremap = true; silent = true; }; };
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

    # default config.lua:
    # https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    plugins.codecompanion.settings = {
      adapters.acp = {
        opts = {
          show_presets = false;
        };
      };
      adapters.http = {
        opts = {
          # Show all available adapters?
          show_presets = false; # default: true
          # Show all available model choices for the selected adapter?
          show_model_choices = true; # default: true
        };
        openai.__raw  = builtins.readFile ./adapters/http/openai.lua;
        gemini.__raw  = builtins.readFile ./adapters/http/gemini.lua;
        lms.__raw     = builtins.readFile ./adapters/http/lmstudio.lua;
        ollama.__raw  = builtins.readFile ./adapters/http/ollama.lua;
      };

      context = {
        providers = [
          { name = "git_diff"; opts = { max_lines = 400; }; }
          { name = "lsp";      opts = { diagnostics = true; definition = true; }; }
          { name = "vectorcode"; opts = { top_k = 15; }; }
        ];
      };

      interactions = {
        # BACKGROUND INTERACTION -------------------------------------------------
        background = {
          adapter = "lms";
          # adapter = {
          #   name = "lms"; # default: copilot
          #   model = "[must not be unset]"; # default: gpt-4.1
          # };
          chat = {
            # INFO: this is enabled by default:
            # - interactions.background.builtin.chat_make_title
            opts = {
              # Enable ALL background chat interactions?
              enabled = false; # default: false
            };
          };
        };

        # CHAT INTERACTION -------------------------------------------------------
        chat = {
          adapter = "lms";
          # adapter = {
          #   name = "lms";
          #   model = "[must not be unset]";
          # };
          roles.llm.__raw = ''
            function(adapter)
              return string.format("%s (%s)",
                adapter.formatted_name,
                adapter.model and adapter.model.name or "n/a"
              )
            end
          '';
          # tools = {
          #   web_search = {
          #     opts = {
          #       adapter = ""; # default: tavily
          #     };
          #   };
          # };
          # variables = {
          ## buffer, lsp, viewport
          # };
          # slash_commands = {
          ## buffer, compact, fetch (jina), quickfix, file, help, image, rules, mode (acp only), now, symbols, terminal
          # };
          opts = {
            # system_prompt = ""; moved here
            completion_provider = "cmp"; # blink|cmp|coc default: default (will try in order)
          };
          keymaps = {
            send.modes.i = [ "<C-CR>" "<C-s>" ];
            # regenerate.modes.n = "g,"; # default: gr (overlaps gr_ for lsp stuff)
            # codeblock.modes.n = "gC"; # default: gc (overlaps gcc for 'toggle comment')
            # auto_tool_mode.modes.n = "g."; # default: gta (overlaps gt for 'next tab')
          };
        };

        # INLINE INTERACTION -----------------------------------------------------
        inline = {
          adapter = "lms";
          # adapter = {
          #   name = "lms";
          #   model = "[must not be unset]";
          # };
          keymaps = {
            # accept_change.modes.n = ""; # default: ga
            # reject_change.modes.n = ""; # default: gr
          };
        };

        # CMD INTERACTION --------------------------------------------------------
        cmd = {
          adapter = "lms";
          # adapter = {
          #   name = "lms";
          #   model = "[must not be unset]";
          # };
        };
      };

      # PROMPT LIBRARIES ---------------------------------------------------------
      prompt_library = {
        # Run `:CodeCompanionActions refresh` to apply changes without nvim restart
        markdown = {
          dirs.__raw = ''{
            vim.fn.getcwd() .. "/.prompts",
          }'';
        };
      }
      # // import ./prompts.nix
      ;

      # RULES -------------------------------------------------------------------
      rules = {
        opts = {
          chat = {
            # Automatically add memory to new chat buffers?
            enabled = true; # default: false
            # autoload.__raw = ''
            #   ---@return string|string[]
            #   function()
            #     local cwd = vim.fn.getcwd()
            #     if cwd:match("zmk") then
            #       return { "default", "zmk" }
            #     elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
            #       return { "default", "rust" }
            #     elseif vim.fn.filereadable(cwd .. "/composer.json") == 1 then
            #       return { "default", "symfony" }
            #     elseif cwd:match("deck/nixos") then
            #       return { "default", "nix", "steamdeck" }
            #     elseif cwd:match("me/nixos") then
            #       return { "default", "nix" }
            #     else
            #       return "default"
            #     end
            #   end,
            # '';
          };
        };
      }
        // (import ./rules/hardware.nix)
        // (import ./rules/network.nix)
        // (import ./rules/nix.nix);

      # DISPLAY OPTIONS ----------------------------------------------------------
      display = {
        action_palette = {
          # Remember: I only like default here
          provider = "default"; # telescope|fzf_lua|mini_pick|snacks|default*
          opts = {
            # Show the default actions in the action palette?
            show_preset_actions = true; # default: true
            # Show the default prompt library in the action palette?
            show_preset_prompts = true; # default: true
            # Show the preset rules in the action palette?
            show_preset_rules = true; # default: true
          };
        };
        chat = {
          window = {
            layout = "vertical"; # float|vertical*|horizontal|buffer
            opts = {
              cursorline = true; # default: false
            };
          };

          # Chat buffer options --------------------------------------------------
          auto_scroll = true; # default: true
          intro_message = ""; # default: "Welcome to CodeCompanion ✨! Press ? for options"
          show_settings = false; # default: false; Show LLM settings at the top of the chat buffer?
          start_in_insert_mode = false; # default: false; Open the chat buffer in insert mode?
        };
        diff = {
          enabled = true;
          provider = "inline"; # mini_diff|split|inline*
          provider_opts = {
            inline = {
              # Where to display the diff
              layout = "float"; # float|buffer
            };
            split = {
              close_chat_at = 200; # default: 240, Close an open chat buffer if the total columns of your display are less than...
              layout = "vertical"; # vertical*|horizontal split for default provider
              # opts = [
              #   "internal"
              #   "filler"
              #   "closeoff"
              #   "algorithm:histogram" # https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram
              #   "indent-heuristic" # https://blog.k-nut.eu/better-git-diffs
              #   "followwrap"
              #   "linematch:120"
              # ];
            };
          };
        };
        inline = {
          # If the inline prompt creates a new buffer, how should we display this?
          layout = "vertical"; # vertical*|horizontal|buffer
        };
      };

      # EXTENSIONS ------------------------------------------------------
      extensions = {
        # import nix files in ./extensions/
        # currently integrated:
        # ./extensions/history.nix
        # ./extensions/spinner.nix
        # ./extensions/vectorcode.nix
      };

      # GENERAL OPTIONS ----------------------------------------------------------
      opts = {
        log_level = "ERROR"; # TRACE|DEBUG|ERROR*|INFO
        # Delay in milliseconds between cmd tools
        job_start_delay = 1500; # default: 1500
        # Delay in milliseconds before auto-submitting the chat buffer
        submit_delay = 2000; # default: 2000
      };
    };

    # Suggested Plugin Workflow
    # https://codecompanion.olimorris.dev/getting-started.html#suggested-plugin-workflow
    # Expand 'cc' into 'CodeCompanion' in the command line
    extraConfigLua = ''
      vim.cmd([[cab cc  CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionCmd]])
    '';
    keymaps = [
      (mapP [ "<leader>."  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" ]  ])
      (mapP [ "<M-.>"      "<cmd>CodeCompanionActions<cr>"       "Actions"            [ "n" "v" "i" ]  ])
      (mapP [ "ga"         "<cmd>CodeCompanionChat Add<cr>"      "Add selection to Chat"  [ "v" ]  ])

      (mapP [ "<C-A>"  ''require("codecompanion").inline_accept_word()''  "Accept Word"   [ "i" ]  ])
      (mapP [ "<C-L>"  ''require("codecompanion").inline_accept_line()''  "Accept Line"   [ "i" ]  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      options.ignore_focus = lib.mkAfter [ "codecompanion" ];
    };
    plugins.render-markdown.settings = {
      # Replace tags with icons:
      # Nerdfont icons:  󰈔   󰈤 󰘓  󰈙   󰈠 󰈞 󱝴 󱅷 
      html.tag = {
        file = {
          icon = "󰈙 ";
          highlight = "Normal";
        };
        rules = {
          icon = "󰘓 ";
          highlight = "Normal";
        };
        tool = {
          icon = " ";
          highlight = "Normal";
        };
        buf = {
          icon = "󰷊 ";
          highlight = "Normal";
        };
      };
    };
  };
}
