{
  programs.nixvim = {
    plugins.tmux-navigator.enable = true;
    keymaps = [
      {
        key = "<m-h>";
        mode = [ "n" ];
        action = "<cmd>TmuxNavigateLeft<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<m-j>";
        mode = [ "n" ];
        action = "<cmd>TmuxNavigateDown<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<m-k>";
        mode = [ "n" ];
        action = "<cmd>TmuxNavigateUp<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<m-l>";
        mode = [ "n" ];
        action = "<cmd>TmuxNavigateRight<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
