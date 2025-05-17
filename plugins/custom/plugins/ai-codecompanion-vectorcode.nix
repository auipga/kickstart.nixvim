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
    # VectorCode integration
    # https://github.com/Davidyz/VectorCode/blob/main/docs/neovim.md
    # https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#olimorriscodecompanionnvim
    # https://github.com/olimorris/codecompanion.nvim/blob/main/doc/extensions/vectorcode.md
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "VectorCode";
        version = "0.6.7";
        src = pkgs.fetchFromGitHub {
          owner = "Davidyz";
          repo = "VectorCode";
          rev = "2815496b98d9002c83d721c71412062196d73b85";
          sha256 = "sha256-yad8ChKEwSy1yFa8v+pGIKBoDxqbvr800wrhyMfedOM=";
        };

        # work around "Require check failed"
        doCheck = false;
      })
      # Dependencies
      pkgs.vimPlugins.plenary-nvim
    ];

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
        timeout_ms = 5000,
        on_setup = {
          update = false, -- set to true to enable update when `setup` is called.
          lsp = false,
        },
        sync_log_env_var = false,
      })
    '';

    # Requirements
    plugins.codecompanion.enable = true;

    # Configure the extension
    plugins.codecompanion.settings = {
      extensions.vectorcode = {
        enabled = true;
        opts = {
          add_tool = true; # the @vectorcode tool becomes available in the CodeCompanion chat buffer
          add_slash_command = true; # the /vectorcode slash command
          tool_opts = {};
        };
      };

#      TODO: make this work
#      context.providers = [ ] ++ [
#        { name = "vectorcode"; opts = { top_k = 15; }; }
#      ];

      hooks = {
        on_pre_send.__raw = ''
          function(payload)
            if payload.dollar_cost and payload.dollar_cost > 1.00 then
              vim.notify("Request aborted: cost ≥ $1", vim.log.levels.WARN)
              return false   -- cancel
            end
          end,
        '';
      };
    };
  };

  # configure the program
  home.file.".vectorcode/config.json".text = ''
    {
      "embedding_params": {
        "backend": "torch",
        "device": "cuda"
      },
    }
  '';

  # zsh completions
  xdg.configFile."zsh/completions/_vectorcode".source = "${vectorcodeCompletion}/_vectorcode";
}
