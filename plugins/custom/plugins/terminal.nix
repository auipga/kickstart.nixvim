{ lib, ... }:
let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/akinsho/toggleterm.nvim
    # https://nix-community.github.io/nixvim/plugins/toggleterm/settings/index.html
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "[[<C-,>]]"; # default: "[[<c-\\>]]";
        auto_scroll = false; # default: true
        direction = "horizontal"; # vertical|horizontal*|tab|float
        start_in_insert = false; # default: true
      };
    };

    keymaps = [
      (map [ "<leader>rr" "<cmd>ToggleTermSendCurrentLine<CR>"      "ToggleTermSendCurrentLine"      "n"  ])
      (map [ "<leader>rr" "<cmd>ToggleTermSendVisualSelection<CR>"  "ToggleTermSendVisualSelection"  "v"  ])

      # Terminal window mappings. See https://github.com/akinsho/toggleterm.nvim/?tab=readme-ov-file#terminal-window-mappings
      # It can be helpful to add mappings to make moving in and out of a terminal easier once toggled, whilst still keeping it open.
      (map [ "<Esc><Esc>" "<C-\\><C-n>"         "Exit terminal mode"              "t"  ]) # official docs use 1x Esc only
      (map [ "jk"         "<C-\\><C-n>"         "Exit terminal mode"              "t"  ])
      (map [ "<C-h>"      "<Cmd>wincmd h<CR>"   "Move focus to the left window"   "t"  ])
      (map [ "<C-j>"      "<Cmd>wincmd j<CR>"   "Move focus to the left window"   "t"  ])
      (map [ "<C-k>"      "<Cmd>wincmd k<CR>"   "Move focus to the lower window"  "t"  ])
      (map [ "<C-l>"      "<Cmd>wincmd l<CR>"   "Move focus to the upper window"  "t"  ])
      # (map [ "<C-w>"      "<C-\\><C-n><C-w>"    null                              "t"  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      extensions = lib.mkAfter [ "toggleterm" ];
    };
  };
}
