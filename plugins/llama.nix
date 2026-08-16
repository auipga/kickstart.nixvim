# plugins/llama.nix
{ pkgs, ... }:
let
  port = "8012";
  host = "pc"; # default: "127.0.0.1"
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
        keymap_fim_trigger = "", -- disable <leader>llf in insert mode
        -- enable_at_startup = false, -- default: true

        -- suggestion from gpt-5.6:
        n_predict = 64, -- default: 128

        -- based on hardware (Low-end with GPU) -- https://github.com/ggml-org/llama.cpp/pull/9787
        ring_n_chunks   = 4, -- default: 16
        ring_chunk_size = 16, -- default: 64
      }
    '';
  };
}
