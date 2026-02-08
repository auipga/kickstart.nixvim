{ pkgs, ... }:
{
  programs.nixvim = {
    # https://github.com/ggml-org/llama.vim
    extraPlugins = [ pkgs.vimPlugins.llama-vim ];

    extraConfigLua = ''
      vim.g.llama_config = {
        -- endpoint_fim  = "http://pc:8080/infill",
        -- endpoint_inst = "http://pc:8080/v1/chat/completions",
      }
    '';
  };
}
