# plugins/toggleterm.nix
{ lib, ... }:
let
  kmap = import ../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    # https://github.com/akinsho/toggleterm.nvim
    # https://nix-community.github.io/nixvim/plugins/toggleterm/settings/index.html
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "{ [[<C-t>]] }"; # default: "[[<c-\\>]]";
        auto_scroll = false; # default: true
        direction = "horizontal"; # vertical|horizontal*|tab|float
        start_in_insert = false; # default: true
        size = ''
          function(term)
            if term.direction == "horizontal" then
              return vim.o.lines * 0.3
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end
          ''; # default: 12
      };
    };

    keymaps = [
      (kmap [ "<leader>rr" "<cmd>ToggleTermSendCurrentLine<CR>"      "ToggleTermSendCurrentLine"      "n"  ])
      (kmap [ "<leader>rr" "<cmd>ToggleTermSendVisualSelection<CR>"  "ToggleTermSendVisualSelection"  "v"  ])

      # Terminal window mappings. See https://github.com/akinsho/toggleterm.nvim/?tab=readme-ov-file#terminal-window-mappings
      # It can be helpful to add mappings to make moving in and out of a terminal easier once toggled, whilst still keeping it open.
      (kmap [ "<Esc><Esc>" "<C-\\><C-n>"         "Exit terminal mode"              "t"  ]) # official docs use 1x Esc only
      (kmap [ "jk"         "<C-\\><C-n>"         "Exit terminal mode"              "t"  ])
      (kmap [ "<C-h>"      "<Cmd>wincmd h<CR>"   "Move focus to the left window"   "t"  ])
      (kmap [ "<C-j>"      "<Cmd>wincmd j<CR>"   "Move focus to the left window"   "t"  ])
      (kmap [ "<C-k>"      "<Cmd>wincmd k<CR>"   "Move focus to the lower window"  "t"  ])
      (kmap [ "<C-l>"      "<Cmd>wincmd l<CR>"   "Move focus to the upper window"  "t"  ])
      # (kmap [ "<C-w>"      "<C-\\><C-n><C-w>"    null                              "t"  ])
    ];

    # Integrations
    plugins.lualine.settings = {
      extensions = lib.mkAfter [ "toggleterm" ];
    };
  };
}
