# plugins/chatgpt.nix
{ config, ... }:
let
  kmap = import ../lib/mkKeymap.nix { prefix = "[C]hatGPT: "; };
in
{
  programs.nixvim = {
    # https://github.com/jackMort/ChatGPT.nvim/
    # https://nix-community.github.io/nixvim/plugins/chatgpt/index.html
    plugins.chatgpt.enable = true;
    plugins.chatgpt.settings.api_key_cmd = "cat ${config.home.homeDirectory}/.config/sops-nix/secrets/api-keys/work/OPENAI";

    # https://github.com/jackMort/ChatGPT.nvim/#whichkey-plugin-mappings
    # Add these to your whichkey plugin mappings for convenient binds
    keymaps = [
      (kmap [ "<leader>cc"  "<cmd>ChatGPT<CR>"                               "[C]hatGPT"                                 ])
      (kmap [ "<leader>ce"  "<cmd>ChatGPTEditWithInstruction<CR>"            "[E]dit with instruction"      [ "n" "v" ]  ])
      (kmap [ "<leader>cg"  "<cmd>ChatGPTRun grammar_correction<CR>"         "[G]rammar Correction"         [ "n" "v" ]  ])
      (kmap [ "<leader>ct"  "<cmd>ChatGPTRun translate<CR>"                  "[T]ranslate"                  [ "n" "v" ]  ])
      (kmap [ "<leader>ck"  "<cmd>ChatGPTRun keywords<CR>"                   "[K]eywords"                   [ "n" "v" ]  ])
      (kmap [ "<leader>cd"  "<cmd>ChatGPTRun docstring<CR>"                  "[D]ocstring"                  [ "n" "v" ]  ])
      (kmap [ "<leader>ca"  "<cmd>ChatGPTRun add_tests<CR>"                  "[A]dd Tests"                  [ "n" "v" ]  ])
      (kmap [ "<leader>co"  "<cmd>ChatGPTRun optimize_code<CR>"              "[O]ptimize Code"              [ "n" "v" ]  ])
      (kmap [ "<leader>cs"  "<cmd>ChatGPTRun summarize<CR>"                  "[S]ummarize"                  [ "n" "v" ]  ])
      (kmap [ "<leader>cf"  "<cmd>ChatGPTRun fix_bugs<CR>"                   "[F]ix Bugs"                   [ "n" "v" ]  ])
      (kmap [ "<leader>cx"  "<cmd>ChatGPTRun explain_code<CR>"               "E[x]plain Code"               [ "n" "v" ]  ])
      (kmap [ "<leader>cr"  "<cmd>ChatGPTRun roxygen_edit<CR>"               "[R]oxygen Edit"               [ "n" "v" ]  ])
      (kmap [ "<leader>cl"  "<cmd>ChatGPTRun code_readability_analysis<CR>"  "Code Readability Analysis"    [ "n" "v" ]  ])
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>c";
        group = "[C]hatGPT";
        mode = [ "n" "v" ];
      }
    ];
  };
}
