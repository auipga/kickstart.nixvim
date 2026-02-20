#let
#  kmap = import ../lib/mkKeymap.nix { };
#in
{
  programs.nixvim = {
    # Highlight todo, notes, etc in comments
    # https://github.com/folke/todo-comments.nvim/
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    plugins.todo-comments = {
      enable = true;
      settings = {
      };
    };

#    keymaps = [
# TODO: this will override t = tnext/tprevious, T = tlast/trewind
#      (kmap [ "]t"  "<cmd>lua require('todo-comments').jump_next()<CR>"  "Next todo comment" ])
#      (kmap [ "[t"  "<cmd>lua require('todo-comments').jump_prev()<CR>"  "Previous todo comment" ])
#      (kmap [ "]T"  "<cmd>lua require('todo-comments').jump_next({keywords = { \"ERROR\", \"WARNING\" }})<CR>"  "Next error/warning comment" ])
#      (kmap [ "[T"  "<cmd>lua require('todo-comments').jump_prev({keywords = { \"ERROR\", \"WARNING\" }})<CR>"  "Previous error/warning comment" ])
#    ];
  };
}
