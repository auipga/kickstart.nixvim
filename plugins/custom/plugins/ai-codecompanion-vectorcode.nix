{
  programs.nixvim = {
    # Integrate VectorCode into CodeCompanion
    # https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#olimorriscodecompanionnvim

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode = {
        enabled = true;
        opts = {
        };
      };

      # Setup: add to context.providers in ./ai-codecompanion.nix
      # { name = "vectorcode"; opts = { top_k = 15; }; }
    };
  };
}
