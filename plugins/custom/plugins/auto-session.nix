let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "[S]ession "; };
in
{
  programs.nixvim = {
    # https://github.com/rmagatti/auto-session
    # https://nix-community.github.io/nixvim/plugins/auto-session/index.html
    plugins.auto-session.enable = true;
    plugins.auto-session = {
      luaConfig.pre = ''
        -- Recommended sessionoptions config
        -- https://github.com/rmagatti/auto-session/#recommended-sessionoptions-config
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
        -- which is equivalent to (VimL):
        -- set sessionoptions+=winpos,folds
      '';
      settings = {
        suppressed_dirs = [
          "~/"
          "~/dev"
          "~/Downloads"
          "/"
        ];

        use_git_branch = true;
      };
    };

    keymaps = [
      (mapP [ "<leader>SW"  "<cmd>AutoSession save<CR>"           "Save / [W]rite"   ])
      (mapP [ "<leader>SS"  "<cmd>AutoSession search<CR>"         "[S]earch..."      ])
      (mapP [ "<leader>SD"  "<cmd>Autosession delete<CR>"         "[D]elete..."      ])
      (mapP [ "<leader>S!"  "<cmd>AutoSession toggle<CR>"         "Toggle autosave"  ])
      (mapP [ "<leader>Sx"  "<cmd>AutoSession purgeOrphaned<CR>"  "Remove orphaned"  ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>S";
        group = "[S]ession";
      }
    ];
  };
}
