{
  programs.nixvim = {
    plugins.auto-session.enable = true;
    plugins.auto-session = {
      luaConfig.pre = ''
        -- Recommended sessionoptions config
        -- https://github.com/rmagatti/auto-session/#recommended-sessionoptions-config
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        -- which is equivalent to (VimL):
        -- set sessionoptions+=winpos,terminal,folds
      '';
      settings = {
      };
    };
  };
}
