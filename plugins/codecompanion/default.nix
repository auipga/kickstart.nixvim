let
  defaultAdapter = "openai"; # openai|gemini|lms|ollama|llama-cpp
  # defaultAdapter = {
  #   name = "lms"; # openai|gemini|lms|ollama|llama-cpp
  #   model = "[must not be unset]";
  # };
in
{
  imports = [
    ./integrations.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    # AI-powered coding, seamlessly in Neovim
    # https://github.com/olimorris/codecompanion.nvim/
    # https://nix-community.github.io/nixvim/plugins/codecompanion/index.html
    plugins.codecompanion.enable = true;

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
        llama-cpp.__raw = builtins.readFile ./adapters/http/llama-cpp.lua;
        inception.__raw = builtins.readFile ./adapters/http/inception.lua;
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
          adapter = defaultAdapter;
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
          adapter = defaultAdapter;
          roles.llm.__raw = ''
            function(adapter)
              return string.format("%s (%s)",
                adapter.formatted_name,
                adapter.model and adapter.model.name or "n/a"
              )
            end
          '';
          tools = {
            # for reference and later use:
            # web_search = {
            #   opts = {
            #     adapter = ""; # default: tavily
            #   };
            # };
          };
          # editor_context = {
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
            # just prepare to change gr
            #regenerate.modes.n = "gr"; # default: gr (overlaps gr_ for lsp stuff)

            # ga sends selection to the chat, creating an empty codeblock feels more related than change_adapter
            codeblock.modes.n = "ga"; # default: gc (overlaps gcc for 'toggle comment')

            # gm for change [m]odel
            change_adapter.modes.n = "g<space>"; # default: ga

            # z for folding
            fold_code.modes.n = "gz"; # default: gf (overlaps gf for 'goto file')

            # just prepare to change gty
            #yolo_mode.modes.n = "gty"; # default: gty (overlaps gt for 'next tab')

            # gf is vims default for goto_file
            goto_file_under_cursor.modes.n = "gf"; # default: gR
          };
        };

        # INLINE INTERACTION -----------------------------------------------------
        inline = {
          adapter = defaultAdapter;
          keymaps = {
            # accept_change.modes.n = ""; # default: ga
            # reject_change.modes.n = ""; # default: gr
          };
        };

        # CMD INTERACTION --------------------------------------------------------
        cmd = {
          adapter = defaultAdapter;
        };
      };

      # PROMPT LIBRARIES ---------------------------------------------------------
      prompt_library = {
        # Run `:CodeCompanionActions refresh` to apply changes without nvim restart
        markdown = {
          dirs.__raw = ''{
            vim.fn.getcwd() .. "/.prompts",
            "~/dev/prompts/CodeCompanion"
          }'';
        };
      }
      # // import ./prompts.nix
      ;

      # RULES -------------------------------------------------------------------
      rules = {
        opts = {
          chat = {
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
            layout = "vertical"; # float|vertical*|horizontal|tab|buffer
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
          word_highlights = {
            additions = true; # default: true
            deletions = true; # default: true
          };
        };
        inline = {
          # If the inline prompt creates a new buffer, how should we display this?
          layout = "vertical"; # vertical*|horizontal|tab|buffer
        };
      };

      # EXTENSIONS ------------------------------------------------------
      extensions = {
        # import nix files in ./extensions/
        # currently integrated:
        # ./extensions/history.nix
        # ./extensions/mcp-hub.nix
        # ./extensions/spinner.nix
        # ./extensions/vectorcode.nix
      };

      # GENERAL OPTIONS ----------------------------------------------------------
      opts = {
        log_level = "ERROR"; # TRACE|DEBUG|ERROR*|INFO
        # Enable per-project configuration?
        per_project_config.enabled = true;
        # Files in the cwd that contain project configuration
        per_project_config.files = [
        ];
        per_project_config.paths = {
        };
        # Delay in milliseconds before auto-submitting the chat buffer
        submit_delay = 500; # default: 500
      };
    };

    # Suggested Plugin Workflow
    # https://codecompanion.olimorris.dev/getting-started.html#suggested-plugin-workflow
    # Expand 'cc' into 'CodeCompanion' in the command line
    extraConfigLua = "vim.cmd([[cab cc CodeCompanion]])";
  };
}
