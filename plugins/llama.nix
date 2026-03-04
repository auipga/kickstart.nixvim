{ osConfig, pkgs, ... }:
let
  port = toString osConfig.services.llama-cpp.port; # default: 8012
  host = if osConfig.services.llama-cpp.openFirewall then "pc" else "127.0.0.1"; # default: "127.0.0.1"
in
{
  programs.nixvim = {
    # https://github.com/ggml-org/llama.vim
    extraPlugins = [ pkgs.vimPlugins.llama-vim ];

    extraConfigLua = ''
      vim.g.llama_config = {
        endpoint_fim  = "http://${host}:${port}/infill", -- default: "http://127.0.0.1:8012/infill"
        endpoint_inst = "http://${host}:${port}/v1/chat/completions", -- default: "http://127.0.0.1:8012/v1/chat/completions"
        -- show_info = 2, -- 0|1|2*  0 - disabled, 1 - statusline, 2 - inline
        -- show_prompt = false, -- default: true
        -- show_message = true, -- default: true
        auto_fim = false, -- default: true
        -- enable_at_startup = false, -- default: true
      }
    '';
  };
}
