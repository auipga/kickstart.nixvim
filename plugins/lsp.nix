# plugins/lsp.nix
let
  # NOTE: Remember that Nix is a real programming language, and as such it is possible
  # to define small helper and utility functions so you don't have to repeat yourself.
  #
  # In this case, we create a function that lets us more easily define mappings.
  # It sets the mode, buffer and description for us each time.
  kmap = import ../lib/mkKeymap.nix { prefix = "LSP: "; };
  mkPluginKeymaps = import ../lib/mkPluginKeymap.nix { };
in
{
  programs.nixvim = {
    # Allows extra capabilities providied by nvim-cmp
    # https://github.com/hrsh7th/cmp-nvim-lsp/
    # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp/index.html
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    # Useful status updates for LSP.
    # https://github.com/j-hui/fidget.nvim
    # https://nix-community.github.io/nixvim/plugins/fidget/index.html
    plugins.fidget = {
      enable = false; # switched to ./noice.nix
      settings.progress.display.done_ttl = 6; # default: 3
      settings.progress.display.skip_history = false; # default: true
    };

    autoGroups = {
      "kickstart-lsp-attach" = {
        clear = true;
      };
    };

    # https://github.com/neovim/nvim-lspconfig/
    # https://nix-community.github.io/nixvim/plugins/lsp/index.html
    plugins.lsp = {
      enable = true;

      #  Add any additional override configuration in the following tables. Available keys are:
      #  - cmd: Override the default command used to start the server
      #  - filetypes: Override the default list of associated filetypes for the server
      #  - capabilities: Override fields in capabilities. Can be used to disable certain LSP features.
      #  - settings: Override the default settings passed when initializing the server.
      #        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      servers = {
        # List of pre-configured LSPs:
        # https://nix-community.github.io/nixvim/plugins/lsp
        #
        # Some languages (like typescript) have entire language plugins that can be useful:
        #    `https://nix-community.github.io/nixvim/plugins/typescript-tools/index.html`
        #
        # But for many setups the LSP (`ts_ls`) will work just fine
        # ts_ls = {
        #   enable = true;
        # };

        # https://github.com/luals/lua-language-server
        # https://nix-community.github.io/nixvim/plugins/lsp/servers/lua_ls/index.html
        lua_ls = {
          enable = true;

          # cmd = [
          # ];
          # filetypes = [
          # ];
          settings = {
            completion = {
              callSnippet = "Replace";
            };
            diagnostics = {
              # disable = [
              #   "missing-fields"
              # ];
            };
          };
        };

        # https://github.com/bash-lsp/bash-language-server
        # https://nix-community.github.io/nixvim/plugins/lsp/servers/bashls/index.html
        bashls.enable = true;

        jsonls.enable = true;
      };

      keymaps = {
        # Diagnostic keymaps
        diagnostic = mkPluginKeymaps [
          [ "<leader>q"  "setloclist"  "Open diagnostic [Q]uickfix list"  ]
        ];

        extra = [
          # Jump to the definition of the word under your cusor.
          #  This is where a variable was first declared, or where a function is defined, etc.
          #  To jump back, press <C-t>.
          (kmap [ "gd"          "<cmd>Telescope lsp_definitions<cr>"                "[G]oto [D]efinition"      ])
          # Find references for the word under your cursor.
          (kmap [ "gR"          "<cmd>Telescope lsp_references<cr>"                 "[G]oto [R]eferences"      ])
          # Jump to the implementation of the word under your cursor.
          #  Useful when your language has ways of declaring types without an actual implementation.
          (kmap [ "gI"          "<cmd>Telescope lsp_implementations<cr>"            "[G]oto [I]mplementation"  ])
          # Jump to the type of the word under your cursor.
          #  Useful when you're not sure what type a variable is and you want to see
          #  the definition of its *type*, not where it was *defined*.
          (kmap [ "<leader>D"   "<cmd>Telescope lsp_type_definitions<cr>"           "Type [D]efinition"        ])
          # Fuzzy find all the symbols in your current document.
          #  Symbols are things like variables, functions, types, etc.
          (kmap [ "<leader>ds"  "<cmd>Telescope lsp_document_symbols<cr>"           "[D]ocument [S]ymbols"     ])
          # Fuzzy find all the symbols in your current workspace.
          #  Similar to document symbols, except searches over your entire project.
          (kmap [ "<leader>ws"  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>"  "[W]orkspace [S]ymbols"    ])
        ];

        lspBuf = mkPluginKeymaps [
          # Rename the variable under your cursor.
          #  Most Language Servers support renaming across files, etc.
          [ "<leader>rn"  "rename"       "LSP: [R]e[n]ame"             "n"    ]
          # Execute a code action, usually your cursor needs to be on top of
          #  an error or a suggestion from your LSP for this to activate.
          [ "<leader>ca"  "code_action"  "LSP: [C]ode [A]ction"  [ "n" "x" ]  ]
        ];
      };

      onAttach = ''
        -- The following two autocommands are used to highlight references of the
        -- word under the cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
           vim.keymap.set('n', '<leader>th', function()
               vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
             end, { buffer = bufnr, desc = 'LSP: [T]oggle Inlay [H]ints' })
        end
      '';
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>w";
        group = "[W]orkspace";
      }
      {
        __unkeyed-1 = "<leader>d";
        group = "[D]ocument";
      }
      {
        __unkeyed-1 = "<leader>r";
        group = "[R]ename";
      }
      # {
      #   __unkeyed-1 = "<leader>c";
      #   group = "[C]ode";
      # This would override '[C]hatGPT' from ai-chatgpt.nix
      # }
    ];
  };
}
