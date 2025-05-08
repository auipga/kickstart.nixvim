{ pkgs, ... }:
let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/OliverChao/telescope-picker-list.nvim/
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-picker-list";
        version = "2025-02-07";
        src = pkgs.fetchFromGitHub {
          owner = "OliverChao";
          repo = "telescope-picker-list.nvim";
          rev = "205f0525f1cf3e5988d792e2ed1a4b347e770c4f";
          sha256 = "sha256-c0GmLWaJwjCHMD84seZ9k927mos3V7tcRCDAwJo6kDA=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
    ];

    # dependencies
    plugins.telescope.enable = true; # required
    plugins.todo-comments.enable = true; # for user_pickers

    # manual setup
    plugins.telescope.luaConfig.post = ''
      require("telescope").load_extension("picker_list")
    '';

    plugins.telescope = {
      settings = {
        extensions = {
          picker_list = {
            excluded_pickers = [
              # suggested
              "fzf"
              "fd"

              # I have a keymap for these:
              "help_tags"
              "keymaps"
              "find_files"
              "builtin"
              "grep_string"
              "live_grep"
              "diagnostics"
              "resume"
              "oldfiles"
              "buffers"
              "command_history"
              "undo"
              "vim_options"
            ];

            # user-defined pickers
            user_pickers.__raw = ''
              {
                { "todo-comments", function() vim.cmd([[TodoTelescope theme=dropdown]]) end },
              }
            '';
          };
        };
      };
    };

    keymaps = [
      (map [ "<leader>ss" "<cmd>Telescope picker_list picker_list<cr>" "[S]earch Telescope Pickers" ])
    ];
  };
}
