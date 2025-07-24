{
  programs.nixvim = {
    # Useful plugin to show you pending keybinds.
    # https://github.com/folke/which-key.nvim
    # https://nix-community.github.io/nixvim/plugins/which-key/index.html
    plugins.which-key = {
      enable = true;

      # Document existing key chains
      settings = {
        # Expand groups when <= n mappings.
        expand = 0;

        preset = "modern"; # bordered, bottom, wide, multi column
        # preset = "helix"; # bordered, bottom right, single column

        sort = [
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
        ];

        spec = [
          # definitions can be found in the specific plugins by searching for ...
          #   ... plugins.which-key.settings.spec = [
        ];

        win = {
          no_overlap = false; # default: true
        };
      };
    };
  };
}
