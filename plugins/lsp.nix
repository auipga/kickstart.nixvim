{ pkgs, ... }:
let
  # NOTE: Remember that Nix is a real programming language, and as such it is possible
  # to define small helper and utility functions so you don't have to repeat yourself.
  #
  # In this case, we create a function that lets us more easily define mappings.
  # It sets the mode, buffer and description for us each time.
  map = import ../lib/mkKeymap.nix { prefix = "LSP: "; };
  mkPluginKeymaps = import ../lib/mkPluginKeymap.nix ;
in
{
  programs.nixvim = {
    # Dependencies
    # { 'Bilal2453/luvit-meta', lazy = true },
    #
    #
    # Allows extra capabilities providied by nvim-cmp
    # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    # Useful status updates for LSP.
    # https://nix-community.github.io/nixvim/plugins/fidget/index.html
    plugins.fidget = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # NOTE: This is where you would add a vim plugin that is not implemented in Nixvim, also see extraConfigLuaPre below
      #
      # TODO: Add luvit-meta when Nixos package is added
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      "kickstart-lsp-attach" = {
        clear = true;
      };
    };

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
        # clangd = {
        #   enable = true;
        # };
        # gopls = {
        #   enable = true;
        # };
        # pyright = {
        #   enable = true;
        # };
        # rust_analyzer = {
        #   enable = true;
        # };
        # ...etc. See `https://nix-community.github.io/nixvim/plugins/lsp` for a list of pre-configured LSPs
        #
        # Some languages (like typscript) have entire language plugins that can be useful:
        #    `https://nix-community.github.io/nixvim/plugins/typescript-tools/index.html?highlight=typescript-tools#pluginstypescript-toolspackage`
        #
        # But for many setups the LSP (`tsserver`) will work just fine
        # tsserver = {
        #   enable = true;
        # };

        lua_ls = {
          enable = false;

          # cmd = {
          # };
          # filetypes = {
          # };
          settings = {
            completion = {
              callSnippet = "Replace";
            };
            # diagnostics = {
            #   disable = [
            #     "missing-fields"
            #   ];
            # };
          };
        };
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
          (map [ "gd"          "<cmd>Telescope lsp_definitions<cr>"                "[G]oto [D]efinition"      ])
          # Find references for the word under your cursor.
          (map [ "gr"          "<cmd>Telescope lsp_references<cr>"                 "[G]oto [R]eferences"      ])
          # Jump to the implementation of the word under your cursor.
          #  Useful when your language has ways of declaring types without an actual implementation.
          (map [ "gI"          "<cmd>Telescope lsp_implementations<cr>"            "[G]oto [I]mplementation"  ])
          # Jump to the type of the word under your cursor.
          #  Useful when you're not sure what type a variable is and you want to see
          #  the definition of its *type*, not where it was *defined*.
          (map [ "<leader>D"   "<cmd>Telescope lsp_type_definitions<cr>"           "Type [D]efinition"        ])
          # Fuzzy find all the symbols in your current document.
          #  Symbols are things like variables, functions, types, etc.
          (map [ "<leader>ds"  "<cmd>Telescope lsp_document_symbols<cr>"           "[D]ocument [S]ymbols"     ])
          # Fuzzy find all the symbols in your current workspace.
          #  Similar to document symbols, except searches over your entire project.
          (map [ "<leader>ws"  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>"  "[W]orkspace [S]ymbols"    ])
        ];

        lspBuf = mkPluginKeymaps [
          # Rename the variable under your cursor.
          #  Most Language Servers support renaming across files, etc.
          [ "<leader>rn"  "rename"       "LSP: [R]e[n]ame"             "n"    ]
          # Execute a code action, usually your cursor needs to be on top of
          #  an error or a suggestion from your LSP for this to activate.
          [ "<leader>ca"  "code_action"  "LSP: [C]ode [A]ction"  [ "n" "x" ]  ]
          # WARN: This is not Goto Definition, this is Goto Declaration.
          #  For example, in C this would take you to the header.
          [ "gD"          "declaration"  "LSP: [G]oto [D]eclaration"   "n"    ]
        ];
      };

      onAttach = ''
        -- The following two autocommands are used to highlight references of the
        -- word under the cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
           vim.keymap.set('n', '<leader>th', function()
               vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
             end, { buffer = bufnr, desc = 'LSP: [T]oggle Inlay [H]ints' })
        end
      '';
    };
  };
}
