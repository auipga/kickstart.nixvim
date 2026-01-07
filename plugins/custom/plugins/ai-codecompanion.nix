{ lib, ... }:
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
                -- max_tokens  = { default = 2048 },
                -- temperature = { default = 0.2 },
                -- top_p       = { default = 0.95 },
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
        lms.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "lmstudio",
              formatted_name = "LM Studio",
              env = {
                url = "http://localhost:1234",
              },
            })
          end
        '';
        ollama_test.__raw = ''
          -- TODO: https://codecompanion.olimorris.dev/extending/adapters#function-calling-tool-use
          function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "ollama_test",
              formatted_name = "ollama",
              schema = {
                model       = { default = "mistral:7b-instruct-v0.3-q4_K_M" },
                num_ctx     = { default = 16384 },
                think       = { default = false },
                keep_alive  = { default = "5m" },
                max_tokens  = { default = 2000 },
                temperature = { default = 0.2 },
                top_p       = { default = 0.95 },
              },
              tools = {
                enabled = true,
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

      interactions = {
        chat = {
          adapter = "lms";
          # adapter = {
          #   name = "lms";
          #   model = "[must not be unset]";
          # };
          roles.llm.__raw = ''function(adapter) return adapter.formatted_name .. " (" .. adapter.model.name .. ")" end'';
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
        cmd = {
          adapter = "lms";
          # adapter = {
          #   name = "lms";
          #   model = "[must not be unset]";
          # };
        };
        # background = { # like olimorris
        #   chat = {
        #     opts = {
        #       enabled = true;
        #     };
        #   };
        # };
      };

      prompt_library = {
        # Run `:CodeCompanionActions refresh` to apply changes without nvim restart
        markdown = {
          dirs.__raw = ''{
            vim.fn.getcwd() .. "/.prompts",
          }'';
        };
      }
      # // import ./ai-codecompanion-prompts.nix
      ;

      rules = {
        opts = {
          chat = {
            enabled = true; # Automatically add memory to new chat buffers?
            # autoload.__raw = ''
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

        nix = {
          description = "nixos-config and nixvim";
          enabled = true;
          # enabled.__raw = ''
          #   function()
          #     -- Don't show this group unless in a specific dir
          #     -- TODO: make it work
          #     return vim.fn.getcwd():match("nixos-config")
          #   end
          # '';
          parser = "CodeCompanion";
          files = [
            ".codecompanion/rules/nix.md"
            ".codecompanion/rules/nixvim.md"
          ];
          is_preset = true;
        };

        hardware = {
          description = "[my hardware]";
          enabled = true;
          parser = "CodeCompanion";
          files = {
            "pc" = {
              description = "My PC specs";
              files = [
               "~/.rules/hardware/default.md"
               "~/.rules/hardware/pc.md"
              ];
            };
            "pc-next" = {
              description = "The next PC";
              files = [
               "~/.rules/hardware/default.md"
               "~/.rules/hardware/pc-next.md"
              ];
            };
            "steamdeck" = {
              description = "My Steam Deck";
              files = [
               "~/.rules/hardware/default.md"
               "~/.rules/hardware/steamdeck.md"
              ];
            };
            "peripherals" = {
              description = "My peripherals";
              files = [
               "~/.rules/hardware/default.md"
               "~/.rules/hardware/peripherals.md"
              ];
            };
            "spare" = {
              description = "My spare hardware";
              files = [
               "~/.rules/hardware/default.md"
               "~/.rules/hardware/spare.md"
              ];
            };
          };
          is_preset = true;
        };

        network = {
          description = "[my network]";
          enabled = true;
          parser = "CodeCompanion";
          files = {
            "internet" = {
              description = "My internet";
              files = [ "~/.rules/network/internet.md" ];
            };
            "router" = {
              description = "My router";
              files = [ "~/.rules/network/router.local.md" ];
            };
            "router-next" = {
              description = "The next router";
              files = [ "~/.rules/network/router-next.md" ];
            };
          };
          is_preset = true;
        };
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
          intro_message = ""; # default: "Welcome to CodeCompanion ✨! Press ? for options"
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
    };

    # Suggested Plugin Workflow
    # https://codecompanion.olimorris.dev/getting-started.html#suggested-plugin-workflow
    # Expand 'cc' into 'CodeCompanion' in the command line
    extraConfigLua = "vim.cmd([[cab cc CodeCompanion]])";
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
