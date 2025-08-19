let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # run a command on each save while the tool is enabled
    # to be replaced with overseer? See https://github.com/stevearc/overseer.nvim
    keymaps = [
      (map [ "<leader>ta"  ":lua project_tool_toggle_autorun()<CR>"  "[T]oggle [a]utorun project tool"  ])
      (map [ "<leader>tr"  ":lua project_tool_run_once()<CR>"        "[T]ool [r]un once" ])
    ];

    extraConfigLua = ''
      local function project_tool_detect()
        local cwd = vim.fn.getcwd()
        if cwd:match("zmk") then
          return {
            name = "just build",
            cmd = "just build hillside52",
            pattern = "*.keymap,*.dtsi,*.conf,*.yml"
          }
        elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
          return {
            name = "check",
            cmd = "cargo check",
            pattern = "*.toml,*.rs"
          }
        elseif vim.fn.filereadable(cwd .. "/composer.json") == 1 then
          return {
            name = "sfcl",
            cmd = "time sfcl -e=prod; date",
            pattern = "*.html.twig,*.php,*.yaml"
          }
        elseif cwd:match("nixos") then
          return {
            name = "build",
            cmd = "nh os test",
            pattern = "*.nix"
          }
        else
          return nil
        end
      end

      function project_tool_run_once()
        local tool = project_tool_detect()
        if not tool then
          vim.notify("No matching project tool detected.")
          return
        end
        vim.cmd("TermExec cmd='" .. tool.cmd .. "'")
        vim.notify("Running " .. tool.name .. "...")
      end

      function project_tool_toggle_autorun()
        local tool = project_tool_detect()
        if not tool then
          vim.notify("No matching project tool detected.")
          return
        end

        -- already enabled?
        if pcall(vim.api.nvim_get_autocmds, { group = "AutorunProjectTool" }) then
          -- disable it
          vim.api.nvim_del_augroup_by_name("AutorunProjectTool")
          vim.notify("Auto " .. tool.name .. " disabled.")
        else
          -- enable it
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("AutorunProjectTool", { clear = true }),
            pattern = tool.pattern,
            callback = function()
              vim.cmd("TermExec cmd='" .. tool.cmd .. "'")
            end,
          })
          vim.notify("Auto " .. tool.name .. " enabled.")
        end
      end
    '';
  };
}
