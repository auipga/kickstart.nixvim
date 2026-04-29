let
  kmapP = import ../lib/mkKeymap.nix { prefix = "Session "; };
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
        allowed_dirs = [
          "~/git/*/*"
        ];
        suppressed_dirs = [
          "~/"
          "~/git/"
          "~/git/*"
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
      (kmapP [ "<leader>ww"  "<cmd>AutoSession search<CR>"         "Search..."          ])
      (kmapP [ "<leader>wW"  "<cmd>AutoSession save<CR>"           "Save / [W]rite"     ])
      (kmapP [ "<leader>wa"  "<cmd>AutoSession toggle<CR>"         "Toggle [a]utosave"  ])
      (kmapP [ "<leader>wx"  "<cmd>AutoSession purgeOrphaned<CR>"  "Remove orphaned"    ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>w";
        group = "Session";
      }
    ];
  };
}
