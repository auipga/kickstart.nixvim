let
  kmapP = import ../../lib/mkKeymap.nix { prefix = "CodeCompanion "; extraOpts = { noremap = true; silent = true; }; };
in
{
  programs.nixvim = {
    keymaps = [
      (kmapP [ "<leader>."  "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" ]  ])
      (kmapP [ "<m-u>"      "<cmd>CodeCompanionChat Toggle<cr>"   "Toggle Chat"        [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (kmapP [ "<m-p>"      "<cmd>CodeCompanionActions<cr>"       "Actions"            [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (kmapP [ "<m-y>"      "<cmd>CodeCompanionSummaries<cr>"     "Summaries"          [ "n" "v" "i" ]  ]) # good for dvorak+hrm
      (kmapP [ "ga"         "<cmd>CodeCompanionChat Add<cr>"      "Add selection to Chat"  [ "v" ]  ])
    ];
  };
}
