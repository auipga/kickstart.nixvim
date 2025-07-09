{ pkgs, config, ... } :
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
        # TODO: use GPG instead env var (https://github.com/olimorris/codecompanion.nvim/discussions/601)
        # TODO: use pass?
        openai_ccc.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai", {
              env = { api_key = vim.env.OPENAI_API_KEY_CCC or "cmd:pass show openai/api-key" },
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
              env = { api_key = vim.env.GEMINI_API_KEY_CCC },
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
              env = { api_key = vim.env.GEMINI_API_KEY },
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
          provider = if config.programs.nixvim.plugins.snacks.enable then "snacks" else "default";
          opts = {
            show_default_actions = true; # Show the default actions in the action palette?
            show_default_prompt_library = true; # Show the default prompt library in the action palette?
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
      };

/*
      opts = {
        system_prompt.__raw = ''
          function(opts)
            local language = opts.language or "English"
            return string.format(
              [[You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code from a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Use the context and attachments the user provides.
- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of each Markdown code block.
- Do not include line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
- Avoid using H1, H2 or H3 headers in your responses as these are reserved for the user.
- Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
- All non-code text responses must be written in the %s language indicated.
- Multiple, different tools can be called as part of the same response.

When given a task:
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
2. Output the final code in a single code block, ensuring that only relevant code is included.
3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
4. Provide exactly one complete reply per conversation turn.
5. If necessary, execute multiple tools in a single turn.]],
              language
            )
          end
        '';
      };
*/

      strategies = {
        chat = {
          adapter = "openai_ccc";
          roles.llm.__raw = ''function(adapter) return adapter.formatted_name end'';
          opts = {
            completion_provider = "cmp"; # blink*|cmp|coc|default
          };
          keymaps = {
            regenerate.modes.n = "g,"; # default: gr (overlaps gr_ for lsp stuff)
            codeblock.modes.n = "gC"; # default: gc (overlaps gcc for 'toggle comment')
            auto_tool_mode.modes.n = "g."; # default: gta (overlaps gt for 'next tab')
          };
        };
        inline = {
          adapter = {
            name = "openai_ccc";
            # model = "";
          };
          keymaps = {
            # accept_change.modes.n = ""; # default: ga
            # reject_change.modes.n = ""; # default: gr
          };
        };
        cmd = {
          adapter = {
            name = "openai_ccc";
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
      (mapP [ "<leader>a"  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" ]  ])
      (mapP [ "<C-a>"      "<cmd>CodeCompanionActions<cr>"       "Actions"            [ "n" "v" ]  ])
      (mapP [ "ga"         "<cmd>CodeCompanionChat Add<cr>"      "Add selection to Chat"  [ "v" ]  ])
    ];
  };
}
