{ pkgs, ... } :
{
  programs.nixvim = {
    # Inline spinner for CodeCompanion in Neovim
    # https://github.com/franco-ruggeri/codecompanion-spinner.nvim
    extraPlugins = [
      pkgs.vimPlugins.codecompanion-spinner-nvim
    ];

    # Enable the extension
    plugins.codecompanion.settings.extensions.spinner.enabled = true;
  };
}
