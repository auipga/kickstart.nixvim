let
  map = args: {
    key = builtins.elemAt args 0;
    action = builtins.elemAt args 1;
    options = {
      desc = "[C]hatGPT: " + builtins.elemAt args 2;
    };
    mode = if builtins.length args > 3 then builtins.elemAt args 3 else "n";
  };
in
{
  programs.nixvim = {
    # https://nix-community.github.io/nixvim/plugins/chatgpt/index.html
    # https://github.com/jackMort/ChatGPT.nvim/
    plugins.chatgpt.enable = true;
    plugins.chatgpt.settings.api_key_cmd = "echo sk-proj--*****";

    # https://nix-community.github.io/nixvim/keymaps/index.html
    # https://github.com/jackMort/ChatGPT.nvim/?tab=readme-ov-file#whichkey-plugin-mappings
    # Add these to your whichkey plugin mappings for convenient binds
    keymaps = [
      (map [ "<leader>cc"  "<cmd>ChatGPT<CR>"                               "[C]hatGPT"                                 ])
      (map [ "<leader>ce"  "<cmd>ChatGPTEditWithInstruction<CR>"            "[E]dit with instruction"      [ "n" "v" ]  ])
      (map [ "<leader>cg"  "<cmd>ChatGPTRun grammar_correction<CR>"         "[G]rammar Correction"         [ "n" "v" ]  ])
      (map [ "<leader>ct"  "<cmd>ChatGPTRun translate<CR>"                  "[T]ranslate"                  [ "n" "v" ]  ])
      (map [ "<leader>ck"  "<cmd>ChatGPTRun keywords<CR>"                   "[K]eywords"                   [ "n" "v" ]  ])
      (map [ "<leader>cd"  "<cmd>ChatGPTRun docstring<CR>"                  "[D]ocstring"                  [ "n" "v" ]  ])
      (map [ "<leader>ca"  "<cmd>ChatGPTRun add_tests<CR>"                  "[A]dd Tests"                  [ "n" "v" ]  ])
      (map [ "<leader>co"  "<cmd>ChatGPTRun optimize_code<CR>"              "[O]ptimize Code"              [ "n" "v" ]  ])
      (map [ "<leader>cs"  "<cmd>ChatGPTRun summarize<CR>"                  "[S]ummarize"                  [ "n" "v" ]  ])
      (map [ "<leader>cf"  "<cmd>ChatGPTRun fix_bugs<CR>"                   "[F]ix Bugs"                   [ "n" "v" ]  ])
      (map [ "<leader>cx"  "<cmd>ChatGPTRun explain_code<CR>"               "E[x]plain Code"               [ "n" "v" ]  ])
      (map [ "<leader>cr"  "<cmd>ChatGPTRun roxygen_edit<CR>"               "[R]oxygen Edit"               [ "n" "v" ]  ])
      (map [ "<leader>cl"  "<cmd>ChatGPTRun code_readability_analysis<CR>"  "Code Readability Analysis"    [ "n" "v" ]  ])
    ];
  };
}
