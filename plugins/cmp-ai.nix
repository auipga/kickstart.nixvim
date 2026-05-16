# plugins/cmp-ai.nix
{
  programs.nixvim = {
    # https://github.com/tzachar/cmp-ai
    # https://nix-community.github.io/nixvim/plugins/cmp-ai/index.html
    plugins.cmp-ai.enable = true;
    plugins.cmp-ai.settings = {
      provider = "Ollama"; # default: HF Bard|Claude|Codestral|HF|Ollama|OpenAI|Tabby
      provider_options = {
        model = "ministral-3:3b";
        auto_unload = false; # automatically unload the model when exiting nvim
      };
      run_on_every_keystroke = true; # default: true
    };

    # dependencies
    plugins.cmp.enable = true;
    plugins.plenary.enable = true;
  };
}
