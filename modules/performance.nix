# modules/performance.nix
{
  # Copied from https://github.com/suasuasuasuasua/nixvim/blob/main/config/user/performance.nix
  programs.nixvim = {
    # Performance tweaks
    # https://nix-community.github.io/nixvim/performance/byteCompileLua.html
    performance = {
      byteCompileLua = {
        enable      = true; # default: false
        configs     = true; # default: true
        initLua     = true; # default: true
        luaLib      = true; # default: false
        nvimRuntime = true; # default: false
        plugins     = true; # default: false
      };
    };
  };
}
