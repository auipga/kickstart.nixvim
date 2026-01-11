let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/kdheepak/lazygit.nvim
    # https://nix-community.github.io/nixvim/plugins/lazygit/index.html
    plugins.lazygit.enable = true;

    keymaps = [
      (map [ "<m-g>"       "<cmd>LazyGitCurrentFile<CR>"  "LazyGitCurrentFile"  ])

      (map [ "<leader>gg"  "<cmd>LazyGit<CR>"             "LazyGit"             ])
      (map [ "<leader>gc"  "<cmd>LazyGitCurrentFile<CR>"  "LazyGitCurrentFile"  ])
      (map [ "<leader>gC"  "<cmd>LazyGitConfig<CR>"       "LazyGitConfig"       ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>g";
        group = "[G]it";
        mode = [ "n" ];
        icon = "󰊢";
      }
    ];
  };
}
