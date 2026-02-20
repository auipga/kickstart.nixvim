let
  mapP = import ../lib/mkKeymap.nix { prefix = "Session "; };
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

        legacy_cmds = false;

        session_lens = {
          mappings = {
            delete_session = [ "i" "<M-d>" ]; # default: <C-d>
          };
        };

        use_git_branch = true;
      };
    };

    keymaps = [
      (mapP [ "<leader>ww"  "<cmd>AutoSession search<CR>"         "Search..."          ])
      (mapP [ "<leader>wW"  "<cmd>AutoSession save<CR>"           "Save / [W]rite"     ])
      (mapP [ "<leader>wa"  "<cmd>AutoSession toggle<CR>"         "Toggle [a]utosave"  ])
      (mapP [ "<leader>wx"  "<cmd>AutoSession purgeOrphaned<CR>"  "Remove orphaned"    ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>w";
        group = "Session";
      }
    ];
  };
}
