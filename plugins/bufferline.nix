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
          mode = "buffers";
          diagnostics = "nvim_lsp";
          always_show_bufferline = true;
          show_buffer_close_icons = true;
          show_close_icon = false;
          separator_style = "slant";
        };
      };
    };

    keymaps = [
      (kmap [ "<S-h>" "<cmd>BufferLineCyclePrev<cr>" "Previous buffer" ])
      (kmap [ "<S-l>" "<cmd>BufferLineCycleNext<cr>" "Next buffer" ])
      (kmap [ "<leader>bp" "<cmd>BufferLinePick<cr>" "Pick buffer" ])
      (kmap [ "<leader>bP" "<cmd>BufferLinePickClose<cr>" "Pick buffer to close" ])
    ];
  };
}
