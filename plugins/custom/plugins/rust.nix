{ lib, ... }:
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
    };

    plugins.dap-ui = {
      enable = true;
    };

    plugins.dap-lldb = { # C, C++, Rust
      enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers = {
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
      };
    };

    plugins.crates.enable = true;

    plugins.cmp.settings.sources = lib.mkAfter [
      { name = "crates"; }
    ];
  };
}
