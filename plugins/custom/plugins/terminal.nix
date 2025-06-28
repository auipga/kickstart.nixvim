let
  map = import ../../../lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    plugins.toggleterm = {
      settings = {
        open_mapping = "[[<C-t>]]"; # default: "[[<c-\\>]]";
        auto_scroll = false;
        direction = "horizontal"; # vertical|horizontal*|tab|float
        start_in_insert = false;
      };
    };

    keymaps = [
      (map [ "<leader>rr" "<cmd>ToggleTermSendCurrentLine<CR>"      "ToggleTermSendCurrentLine"      "n"  ])
      (map [ "<leader>rr" "<cmd>ToggleTermSendVisualSelection<CR>"  "ToggleTermSendVisualSelection"  "v"  ])
    ];
  };
}
