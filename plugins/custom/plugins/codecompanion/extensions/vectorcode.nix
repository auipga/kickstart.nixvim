{
  imports = [
    ../../vectorcode.nix
  ];

  programs.nixvim = {
    # Integrate VectorCode into CodeCompanion
    # https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md#olimorriscodecompanionnvim

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode.enabled = true;

      # Setup: add to context.providers in ../default.nix
      # { name = "vectorcode"; opts = { top_k = 15; }; }
    };
  };
}
