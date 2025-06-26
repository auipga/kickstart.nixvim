let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "{ [[<C-t>]] }"; # default: "[[<c-\\>]]";
        auto_scroll = false;
      };
    };

    # run a command on each save
    # to be replaced with overseer
    # see https://github.com/stevearc/overseer.nvim
    keymaps = [
      (map [ "<leader>rl" "<cmd>ToggleTermSendCurrentLine<CR>"  "ToggleTermSendCurrentLine"  ])
      (map [ "<leader>."  "<cmd>ToolPicker<CR>"  "Tool Picker"  ])
    ];
    extraConfigLua = ''
      -- Detect project type by known markers
      local function detect_project_type()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
          return "rust"
        elseif vim.fn.filereadable(cwd .. "/composer.json") == 1 then
          return "php"
        elseif vim.fn.filereadable(cwd .. "/flake.nix") == 1 then
          return "nix"
        elseif cwd:match("zmk") then
          return "zmk"
        end
      end

      -- Define task runners for each type
      local function register_autorun(filetype, action)
        local group = vim.api.nvim_create_augroup("ProjectTaskRunner", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = group,
          pattern = "*." .. filetype,
          callback = action,
        })
      end

      local function start_project_tool_picker()
        local project_type = detect_project_type()
        if not project_type then
          vim.notify("No matching project type detected.")
          return
        end

        local tools = {
          nix = {
            ["Enable: nh os switch"] = function()
              register_autorun("nix", function()
                -- vim.cmd("TermExec cmd='nh os build || exit 1 && read -p \"Apply switch? (y/n): \" yn && [ \"$yn\" = \"y\" ] && nh os switch'")
                vim.cmd("TermExec cmd='nh os switch'")
              end)
              vim.notify("Auto nh os switch enabled.")
            end,
          },
          php = {
            ["Enable: Symfony Clear Cache"] = function()
              register_autorun("sfcl", function()
                vim.cmd("TermExec cmd='time sfcl -e=prod; date'")
              end)
              vim.notify("Auto sfcl enabled.")
            end,
          },
          rust = {
            ["Enable: cargo check"] = function()
              register_autorun("rs", function()
                vim.cmd("TermExec cmd='cargo check'")
              end)
              vim.notify("Auto cargo check enabled.")
            end,
          },
          zmk = {
            ["Enable: west build"] = function()
              register_autorun("keymap", function()
                vim.cmd("TermExec cmd='west build -b nice_nano_v2'")
              end)
              vim.notify("Auto west build enabled.")
            end,
          },
          shared = {
          }
        }

        local project_tools = tools[project_type] or {}
        for name, fn in pairs(tools.shared or {}) do
          project_tools[name] = fn
        end

        local options = vim.tbl_keys(project_tools)
        vim.ui.select(options, {
          prompt = "Select auto command to enable on save:",
        }, function(choice)
          if choice then project_tools[choice]() end
        end)
      end

      vim.api.nvim_create_user_command("ToolPicker", start_project_tool_picker, { desc = "Launch project task picker" })
    '';
  };
}
