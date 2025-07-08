let
  constants = {
    SYSTEM_ROLE = "system";
    USER_ROLE = "user";
  };
in
{
  "Custom Prompt" = {
    strategy = "inline";
    description = "Prompt the LLM from Neovim";
    opts = {
      index = 3;
      is_default = true;
      is_slash_cmd = false;
      user_prompt = true;
    };
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''
          function(context)
            return fmt(
              [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
              context.filetype
            )
          end
        '';
      }
    ];
  };

  "Code workflow" = {
    strategy = "workflow";
    description = "Use a workflow to guide an LLM in writing code";
    opts = {
      index = 4;
      is_default = true;
      short_name = "cw";
    };
    prompts = [
      [
        # We can group prompts together to make a workflow
        # This is the first prompt in the workflow
        {
          role = constants.SYSTEM_ROLE;
          content.__raw = ''
            function(context)
              return fmt(
                "You carefully provide accurate, factual, thoughtful, nuanced answers, and are brilliant at reasoning. If you think there might not be a correct answer, you say so. Always spend a few sentences explaining background context, assumptions, and step-by-step thinking BEFORE you try to answer a question. Don't be verbose in your answers, but do provide details and examples where it might help the explanation. You are an expert software engineer for the %s language",
                context.filetype
              )
            end
          '';
        }
        {
          role = constants.USER_ROLE;
          content = "I want you to ";
          opts = {
            auto_submit = false;
          };
        }
      ]
      # This is the second group of prompts
      [
        {
          role = constants.USER_ROLE;
          content = "Great. Now let's consider your code. I'd like you to check it carefully for correctness, style, and efficiency, and give constructive criticism for how to improve it.";
          opts = {
            auto_submit = true;
          };
        }
      ]
      # This is the final group of prompts
      [
        {
          role = constants.USER_ROLE;
          content = "Thanks. Now let's revise the code based on the feedback, without additional explanations.";
          opts = {
            auto_submit = true;
          };
        }
      ]
    ];
  };

  "Edit<->Test workflow" = {
    strategy = "workflow";
    description = "Use a workflow to repeatedly edit then test code";
    opts = {
      index = 5;
      is_default = true;
      short_name = "et";
    };
    prompts = [
      [
        {
          name = "Setup Test";
          role = constants.USER_ROLE;
          opts = {
            auto_submit = false;
          };
          content.__raw = ''
            function()
              -- Enable turbo mode!!!
              vim.g.codecompanion_auto_tool_mode = true

              return [[### Instructions

Your instructions here

### Steps to Follow

You are required to write code following the instructions provided above and test the correctness by running the designated test suite. Follow these steps exactly:

1. Update the code in #{buffer} using the @{insert_edit_into_file} tool
2. Then use the @{cmd_runner} tool to run the test suite with `<test_cmd>` (do this after you have updated the code)
3. Make sure you trigger both tools in the same response

We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.]]
            end
          '';
        }
      ]
      [
        {
          name = "Repeat On Failure";
          role = constants.USER_ROLE;
          opts = {
            auto_submit = true;
          };
          # Scope this prompt to the cmd_runner tool
          condition.__raw = ''
            function()
              return _G.codecompanion_current_tool == "cmd_runner"
            end
          '';
          # Repeat until the tests pass, as indicated by the testing flag
          # which the cmd_runner tool sets on the chat buffer
          repeat_until.__raw = ''
            function(chat)
              return chat.tools.flags.testing == true
            end
          '';
          content = "The tests have failed. Can you edit the buffer and run the test suite again?";
        }
      ]
    ];
  };

  "Explain" = {
    strategy = "chat";
    description = "Explain how code in a buffer works";
    opts = {
      index = 6;
      is_default = true;
      is_slash_cmd = false;
      modes = [ "v" ];
      short_name = "explain";
      auto_submit = true;
      user_prompt = false;
      stop_context_insertion = true;
    };
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''[[When asked to explain code, follow these steps:

1. Identify the programming language.
2. Describe the purpose of the code and reference core concepts from the programming language.
3. Explain each function or significant block of code, including parameters and return values.
4. Highlight any specific functions or methods used and their roles.
5. Provide context on how the code fits into a larger application if applicable.]]'';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return fmt(
              [[Please explain this code from buffer %d:

```%s
%s
```
]],
              context.bufnr,
              context.filetype,
              code
            )
          end
        '';
        opts = {
          contains_code = true;
        };
      }
    ];
  };

  "Unit Tests" = {
    strategy = "inline";
    description = "Generate unit tests for the selected code";
    opts = {
      index = 7;
      is_default = true;
      is_slash_cmd = false;
      modes = [ "v" ];
      short_name = "tests";
      auto_submit = true;
      user_prompt = false;
      placement = "new";
      stop_context_insertion = true;
    };
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''
[[When generating unit tests, follow these steps:

1. Identify the programming language.
2. Identify the purpose of the function or module to be tested.
3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
4. Generate unit tests using an appropriate testing framework for the identified programming language.
5. Ensure the tests cover:
- Normal cases
- Edge cases
- Error handling (if applicable)
6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.]]'';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return fmt(
              [[<user_prompt>
Please generate unit tests for this code from buffer %d:

```%s
%s
```
</user_prompt>
]],
              context.bufnr,
              context.filetype,
              code
            )
          end
        '';
        opts = {
          contains_code = true;
        };
      }
    ];
  };

  "Fix code" = {
    strategy = "chat";
    description = "Fix the selected code";
    opts = {
      index = 8;
      is_default = true;
      is_slash_cmd = false;
      modes = [ "v" ];
      short_name = "fix";
      auto_submit = true;
      user_prompt = false;
      stop_context_insertion = true;
    };
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''
[[When asked to fix code, follow these steps:

1. **Identify the Issues**: Carefully read the provided code and identify any potential issues or improvements.
2. **Plan the Fix**: Describe the plan for fixing the code in pseudocode, detailing each step.
3. **Implement the Fix**: Write the corrected code in a single code block.
4. **Explain the Fix**: Briefly explain what changes were made and why.

Ensure the fixed code:

- Includes necessary imports.
- Handles potential errors.
- Follows best practices for readability and maintainability.
- Is formatted correctly.

Use Markdown formatting and include the programming language name at the start of the code block.]]'';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return fmt(
              [[Please fix this code from buffer %d:

```%s
%s
```
]],
              context.bufnr,
              context.filetype,
              code
            )
          end
        '';
        opts = {
          contains_code = true;
        };
      }
    ];
  };

  "Explain LSP Diagnostics" = {
    strategy = "chat";
    description = "Explain the LSP diagnostics for the selected code";
    opts = {
      index = 9;
      is_default = true;
      is_slash_cmd = false;
      modes = [ "v" ];
      short_name = "lsp";
      auto_submit = true;
      user_prompt = false;
      stop_context_insertion = true;
    };
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''
[[You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages. When appropriate, give solutions with code snippets as fenced codeblocks with a language identifier to enable syntax highlighting.]]
        '';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function(context)
            local diagnostics = require("codecompanion.helpers.actions").get_diagnostics(
              context.start_line,
              context.end_line,
              context.bufnr
            )

            local concatenated_diagnostics = ""
            for i, diagnostic in ipairs(diagnostics) do
              concatenated_diagnostics = concatenated_diagnostics
              .. i
              .. ". Issue "
              .. i
              .. "\n  - Location: Line "
              .. diagnostic.line_number
              .. "\n  - Buffer: "
              .. context.bufnr
              .. "\n  - Severity: "
              .. diagnostic.severity
              .. "\n  - Message: "
              .. diagnostic.message
              .. "\n"
            end

            return fmt(
              [[The programming language is %s. This is a list of the diagnostic messages:

%s
]],
              context.filetype,
              concatenated_diagnostics
            )
          end
        '';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function(context)
            local code = require("codecompanion.helpers.actions").get_code(
              context.start_line,
              context.end_line,
              { show_line_numbers = true }
            )
            return fmt(
              [[
This is the code, for context:

```%s
%s
```
]],
              context.filetype,
              code
            )
          end
        '';
        opts = {
          contains_code = true;
        };
      }
    ];
  };

  "Generate a Commit Message" = {
    strategy = "chat";
    description = "Generate a commit message";
    opts = {
      index = 10;
      is_default = true;
      is_slash_cmd = true;
      short_name = "commit";
      auto_submit = true;
    };
    prompts = [
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function()
            return fmt(
              [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
              vim.fn.system("git diff --no-ext-diff --staged")
            )
          end
        '';
        opts = {
          contains_code = true;
        };
      }
    ];
  };

  "Workspace File" = {
    strategy = "chat";
    description = "Generate a Workspace file/group";
    opts = {
      index = 11;
      ignore_system_prompt = true;
      is_default = true;
      short_name = "workspace";
    };
    references = [
      {
        type = "file";
        path.__raw = ''
          vim.fs.joinpath(vim.fn.getcwd(), "codecompanion-workspace.json")
        '';
      }
    ];
    prompts = [
      {
        role = constants.SYSTEM_ROLE;
        content.__raw = ''
          function()
            local schema = require("codecompanion").workspace_schema()
            return fmt(
              [[## CONTEXT

A workspace is a JSON configuration file that organizes your codebase into related groups to help LLMs understand your project structure. Each group contains files, symbols, or URLs that provide context about specific functionality or features.

The workspace file follows this structure:

```json
%s
```

## OBJECTIVE

Create or modify a workspace file that effectively organizes the user's codebase to provide optimal context for LLM interactions.

## RESPONSE

You must create or modify a workspace file through a series of prompts over multiple turns:

1. First, ask the user about the project's overall purpose and structure if not already known
2. Then ask the user to identify key functional groups in your codebase
3. For each group, ask the user select relevant files, symbols, or URLs to include. Or, use your own knowledge to identify them
4. Generate the workspace JSON structure based on the input
5. Review and refine the workspace configuration together with the user]],
              schema
            )
          end
        '';
      }
      {
        role = constants.USER_ROLE;
        content.__raw = ''
          function()
            local prompt = ""
            if vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), "codecompanion-workspace.json")) == 1 then
              prompt = [[Can you help me add a group to an existing workspace file?]]
            else
              prompt = [[Can you help me create a workspace file?]]
            end

            local ok, _ = pcall(require, "vectorcode")
            if ok then
              prompt = prompt .. " Use the @{vectorcode_toolbox} tool to help identify groupings of files"
            end
            return prompt
          end
        '';
      }
    ];
  };

}

