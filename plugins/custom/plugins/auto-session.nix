let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "[S]ession "; };
in
{
  programs.nixvim = {
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

        # On startup, loads the last saved session if session for cwd does not exist
        # auto_restore_last_session = true; # default: false;
        # Include git branch name in session name
        # git_use_branch_name = true; # default: false;
        # Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
        # git_auto_restore_on_branch_change = true; # default: false;
        # Whether to show a notification when auto-restoring
        # show_auto_restore_notif = true; # default: false;
        # Follow cwd changes, saving a session before change and restoring after
        # cwd_change_handling = true; # default: false;
        # Should language servers be stopped when restoring a session. Can also be a function that will be called if set. Not called on autorestore from startup
        # lsp_stop_on_restore = true; # default: false;
        # Called when there's an error restoring. By default, it ignores fold errors otherwise it displays the error and returns false to disable auto_save
        # restore_error_handler = null; # default: null;
        # Sets the log level of the plugin (debug, info, warn, error).
        # log_level = "error"; default: "error";
      };
    };

    keymaps = [
      (mapP [ "<leader>SW"  "<cmd>SessionSave<CR>"            "Save / [W]rite"   ])
      (mapP [ "<leader>SS"  "<cmd>SessionSearch<CR>"          "[S]earch..."      ])
      (mapP [ "<leader>SD"  "<cmd>Autosession delete<CR>"     "[D]elete..."      ])
      (mapP [ "<leader>S!"  "<cmd>SessionToggleAutoSave<CR>"  "Toggle autosave"  ])
      (mapP [ "<leader>Sx"  "<cmd>SessionPurgeOrphaned<CR>"   "Remove orphaned"  ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>S";
        group = "[S]ession";
      }
    ];
  };
}
