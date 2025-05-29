{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "[[<c-\\>]]";
      };
    };
  };
}
