{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "{ [[<C-t>]], [[<C-\\>]] }"; # default: "[[<c-\\>]]";
      };
    };
  };
}
