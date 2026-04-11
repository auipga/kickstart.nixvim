let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # run a command on each save while the tool is enabled
    # to be replaced with overseer? See https://github.com/stevearc/overseer.nvim
    keymaps = [
      (kmap [ "<leader>ta"  ":lua project_tool_toggle_autorun()<CR>"  "[T]oggle [a]utorun project tool"  ])
      (kmap [ "<leader>tr"  ":lua project_tool_run_once()<CR>"        "[T]ool [r]un once" ])
    ];

    extraConfigLua = ''
      local plugin = "Autorun Project Tool"
      local group = "AutorunProjectTool"

      local function project_tool_detect()
        local cwd = vim.fn.getcwd()
        if cwd:match("zmk") then
          return {
            name = "just build",
            cmd = "just build hillside52_left",
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
        elseif cwd:match("deck/nixos") then
          return {
            name = "build",
            cmd = "nh home switch",
            pattern = "*.nix"
          }
        elseif cwd:match("me/nixos") then
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
          vim.notify("No matching project tool detected.", vim.log.levels.WARN, { title = plugin })
          return
        end
        vim.cmd("TermExec cmd='" .. tool.cmd .. "'")
        vim.notify("Running " .. tool.name .. "...", vim.log.levels.INFO, { title = plugin })
      end

      function project_tool_toggle_autorun()
        local tool = project_tool_detect()
        if not tool then
          vim.notify("No matching project tool detected.", vim.log.levels.WARN, { title = plugin })
          return
        end

        -- already enabled?
        if pcall(vim.api.nvim_get_autocmds, { group = group }) then
          -- disable it
          vim.api.nvim_del_augroup_by_name(group)
          vim.notify("Auto " .. tool.name .. " disabled.", vim.log.levels.INFO, { title = plugin })
        else
          -- enable it
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup(group, { clear = true }),
            pattern = tool.pattern,
            callback = function()
              vim.cmd("TermExec cmd='" .. tool.cmd .. "'")
            end,
          })
          vim.notify("Auto " .. tool.name .. " enabled.", vim.log.levels.INFO, { title = plugin })
        end
      end
    '';
  };
}
