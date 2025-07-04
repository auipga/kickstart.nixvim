{ pkgs, lib, ... } :
let
  # generate zsh completions
  vectorcodeCompletion = pkgs.runCommand "vectorcode-zsh-completion" {
    nativeBuildInputs = [ pkgs.vectorcode ];
  } ''
    mkdir -p $out
    vectorcode --print-completion zsh > $out/_vectorcode
  '';
  in
{
  programs.nixvim = {
    # With VectorCode, you can easily (and programmatically) inject task-relevant context from the project into the prompt
    # https://github.com/Davidyz/VectorCode/blob/main/docs/neovim.md
    extraPlugins = [
      # pkgs.vimPlugins.vectorcode-nvim # only 0.6.12 for now (26.06.2025) see https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vectorcode-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "vectorcode-nvim";
        version = "0.7.6";
        src = pkgs.fetchFromGitHub {
          owner = "Davidyz";
          repo = "VectorCode";
          tag = "0.7.6";
          sha256 = "sha256-PnvzTEUHFioAdn2RFtnNw+8ZbQMHOU1Jz2o20KLVmQQ=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
      # Dependencies
      pkgs.vimPlugins.plenary-nvim
    ];

    # these are the defaults from https://github.com/Davidyz/VectorCode/blob/main/docs/neovim.md#configuration
    plugins.codecompanion.luaConfig.post = lib.mkAfter ''
      require("vectorcode").setup({
        async_opts = {
          debounce = 10,
          events = { "BufWritePost", "InsertEnter", "BufReadPost" },
          exclude_this = true,
          n_query = 1,
          notify = false,
          query_cb = require("vectorcode.utils").make_surrounding_lines_cb(-1),
          run_on_register = false,
        },
        async_backend = "default", -- or "lsp"
        exclude_this = true,
        n_query = 1,
        notify = true,
        timeout_ms = 30000,
        on_setup = {
          update = false, -- set to true to enable update when `setup` is called.
          lsp = false,
        },
        sync_log_env_var = false,
      })
    '';

    plugins.lsp.servers.vectorcode_server = {
      enable = true;
    };
  };

  # configure the program
  # for intel:
  # home.file.".vectorcode/config.json".text = ''
  #   {
  #     "embedding_params": {
  #       "backend": "openvino"
  #     }
  #   }
  # '';
  # for nvidia:
  # home.file.".vectorcode/config.json".text = ''
  #   {
  #     "embedding_params": {
  #       "backend": "torch",
  #       "device": "cuda"
  #     }
  #   }
  # '';

  # zsh completions
  xdg.configFile."zsh/completions/_vectorcode".source = "${vectorcodeCompletion}/_vectorcode";
}
