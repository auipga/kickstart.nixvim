{
  programs.nixvim = {
    # https://github.com/wakatime/vim-wakatime/
    # https://nix-community.github.io/nixvim/plugins/wakatime.html
    plugins.wakatime.enable = true;
    # Setup:
    # Copy Secret API Key from here:
    # https://wakatime.com/settings/api-key
    # and paste it into:
    # :WakaTimeApiKey<cr>
    # https://wakatime.com/settings/account
  };
}
