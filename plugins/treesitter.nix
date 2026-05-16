# plugins/treesitter.nix
{ pkgs, ... }:
{
  programs.nixvim = {
    # Highlight, edit, and navigate code
    # https://github.com/nvim-treesitter/nvim-treesitter
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    plugins.treesitter = {
      enable = true;

      folding.enable = true;

      # Installing tree-sitter grammars from Nixpkgs (recommended)
      # https://nix-community.github.io/nixvim/plugins/treesitter/index.html#installing-tree-sitter-grammars-from-nixpkgs
      # grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        # Linux
        bash
        ssh_config
        # sway

        # Nix, Nixvim
        nix
        query # treesitter queries
        vim
        vimdoc
        lua
        luadoc

        # General Development
        csv
        diff
        editorconfig
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        ini
        # llvm
        markdown
        markdown_inline
        regex
        xml
        yaml

        # Web Development
        css
        html
        http
        javascript
        json
        json5
        sql
        scss
        twig
        tsx
        typescript

        # Web - other
        # astro
        # nginx
        # svelte
      ];

      settings = {
        # Installing tree-sitter grammars from nvim-treesitter
        # (can be combined with grammarPackages from Nixpkgs)
        # https://nix-community.github.io/nixvim/plugins/treesitter/index.html#installing-tree-sitter-grammars-from-nvim-treesitter
#        ensureInstalled = "all"; # should make them available but not really install them all
        ensureInstalled = [
        ];

        highlight = {
          enable = true;

          # Some languages depend on vim's regex highlighting system for indent rules.
          additional_vim_regex_highlighting = [
            "ruby"
          ];
        };

        # see `:help nvim-treesitter-incremental-selection-mod`
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_decremental = "grm"; # default: grm
            node_incremental = "grn"; # default: grn
            scope_incremental = "grc"; # default: grc
          };
        };

        indent = {
          enable = true;
          disable = [
            "ruby"
          ];
        };
      };
    };
  };
}
