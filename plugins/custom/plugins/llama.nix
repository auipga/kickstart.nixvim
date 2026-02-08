{ pkgs, ... }:
{
  programs.nixvim = {
    # https://github.com/ggml-org/llama.vim
    extraPlugins = [ pkgs.vimPlugins.llama-vim ];

    extraConfigLua = ''
      vim.g.llama_config = {
      }
    '';
  };
}
