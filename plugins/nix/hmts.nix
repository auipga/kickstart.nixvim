# plugins/nix/hmts.nix
{ pkgs, ... }:
{
  programs.nixvim = {
    # Custom treesitter queries for Home Manager nix files
    # https://github.com/calops/hmts.nvim
    # https://nix-community.github.io/nixvim/plugins/hmts/index.html
    plugins.hmts.enable = false;

    # replaced with a fork:
    # https://github.com/charliie-dev/hmts.nvim/tree/combined-fixes
    extraPlugins = with pkgs; [
      (vimUtils.buildVimPlugin {
        pname = "hmts.nvim";
        version = "1.3.0"; # 16.05.2026 https://github.com/charliie-dev/hmts.nvim/tags
        src = fetchFromGitHub {
          owner = "charliie-dev"; # default: calops
          repo = "hmts.nvim";
          rev = "15afe9503a2884395f00d88ea697c88aadee8619"; # branch 'combined-fixes'
          sha256 = "sha256-7Wnb0UxhSwWxPgabmlQlc8JlDD4alF0PBlhM9oM7pTc=";
        };
      })
    ];
  };
}
