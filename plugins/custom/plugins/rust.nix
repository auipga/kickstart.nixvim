{ lib, ... }:
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
    };

    plugins.dap-ui = {
      enable = true;
    };

#    plugins.neotest.adapters.rust.enable = true;

    plugins.dap-lldb = { # C, C++, Rust
      enable = true;
    };

    # https://github.com/mrcjkb/rustaceanvim
    # https://nix-community.github.io/nixvim/plugins/rustaceanvim/index.html
    plugins.rustaceanvim.enable = false;

    plugins.lsp = {
      enable = true;
      ## servers OR rustaceanvim !
      servers = {
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };

    plugins.crates.enable = true;

    plugins.cmp.settings.sources = lib.mkAfter [
      { name = "crates"; }
    ];
  };
}
