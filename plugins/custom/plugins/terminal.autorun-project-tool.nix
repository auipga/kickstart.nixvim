let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # run a command on each save while the tool is enabled
    # to be replaced with overseer? See https://github.com/stevearc/overseer.nvim
    keymaps = [
      (map [ "<leader>tt"  ":lua toggle_autorun_project_tool()<CR>"  "[T]oggle autorun project [t]ool"  ])
    ];

    extraConfigLua = ''
      function toggle_autorun_project_tool()
        local cwd = vim.fn.getcwd()
        local tool

        -- detect project type and define its tool
        if cwd:match("zmk") then
          tool = {
            name = "just build",
            cmd = "just build hillside52",
            pattern = "*.keymap,*.dtsi,*.conf,*.yml"
          }
        elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
          tool = {
            name = "check",
            cmd = "cargo check",
            pattern = "*.toml,*.rs"
          }
        elseif vim.fn.filereadable(cwd .. "/composer.json") == 1 then
          tool = {
            name = "sfcl",
            cmd = "time sfcl -e=prod; date",
            pattern = "*.html.twig,*.php,*.yaml"
          }
        elseif cwd:match("nixos") then
          tool = {
            name = "switch",
            cmd = "nh os switch",
            pattern = "*.nix"
          }
        else
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
