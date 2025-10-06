{
  programs.nixvim = {
    # https://github.com/wakatime/vim-wakatime/
    # https://nix-community.github.io/nixvim/plugins/wakatime.html
    plugins.wakatime.enable = true;
    # Setup:
    # :WakaTimeApiKey<cr>
    # https://wakatime.com/settings/account
  };
}
