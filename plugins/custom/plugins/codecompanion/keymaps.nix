let
  mapP = import ../../../../lib/mkKeymap.nix { prefix = "CodeCompanion "; extraOpts = { noremap = true; silent = true; }; };
in
{
  programs.nixvim = {
    keymaps = [
      (mapP [ "<leader>."  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" ]  ])
      (mapP [ "<m-u>"      "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (mapP [ "<m-p>"      "<cmd>CodeCompanionActions<cr>"       "Actions"            [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (mapP [ "<m-y>"      "<cmd>CodeCompanionSummaries<cr>"     "Summaries"          [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (mapP [ "ga"         "<cmd>CodeCompanionChat Add<cr>"      "Add selection to Chat"  [ "v" ]  ])
    ];
  };
}
