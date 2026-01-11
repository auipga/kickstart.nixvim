{ config, pkgs, lib, ... } :
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
    # Easily (and programmatically) inject task-relevant context from the project into the prompt
    # https://github.com/Davidyz/VectorCode/tree/main/docs/neovim
    extraPlugins = [
      # pkgs.vimPlugins.vectorcode-nvim # latest 0.7.19 (01.12.2025)
      pkgs.vimPlugins.vectorcode-nvim # only 0.7.19 for now (21.12.2025) see https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vectorcode-nvim

      /*
      (pkgs.vimUtils.buildVimPlugin {
        pname = "vectorcode.nvim";
        version = "0.7.20";
        src = pkgs.fetchFromGitHub {
          owner = "Davidyz";
          repo = "VectorCode";
          tag = "0.7.20";
          sha256 = "sha256-RU9WnKuPaxDnPW5MQyrxPEw7ufMcVNxSRyJ5QvrzoVs=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
      */
    ];

    # these are the defaults from https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md#configuration
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
        async_backend = "lsp", -- default|lsp
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

    plugins.lsp.servers.vectorcode_server.enable = true;
  };

  programs.zsh.shellAliases.vc = "vectorcode";

  programs.zsh.initContent = ''
    # vectorcode completion
    fpath=(${config.xdg.configHome}/zsh/completions $fpath)
  '';

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
