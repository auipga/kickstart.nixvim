{ ... }:
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/akinsho/bufferline.nvim
    # https://nix-community.github.io/nixvim/plugins/bufferline/index.html
    plugins.bufferline = {
      enable = true;

      settings = {
        options = {
          mode = "tabs"; # tabs|buffers
          diagnostics = "nvim_lsp";
          always_show_bufferline = true;
          show_buffer_close_icons = false;
          show_close_icon = false;
          separator_style = "slant";
          hover = {
            enabled = true;
            delay = 200;
            reveal = ["close"];
          };

        };
      };
    };

    keymaps = [
      (kmap [ "<S-Left>"   "<cmd>BufferLineCyclePrev<cr>" "Previous buffer" ])
      (kmap [ "<S-Right>"  "<cmd>BufferLineCycleNext<cr>" "Next buffer" ])
      (kmap [ "<leader>bp" "<cmd>BufferLinePick<cr>"      "Pick buffer" ])
      (kmap [ "<leader>bP" "<cmd>BufferLinePickClose<cr>" "Pick buffer to close" ])
    ];
  };
}
