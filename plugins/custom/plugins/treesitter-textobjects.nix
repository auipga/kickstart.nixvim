{
  programs.nixvim = {
    # https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
    # https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    plugins.treesitter-textobjects = {
      enable = true;

      lspInterop = {
        enable = true;

        border = "none";
        floatingPreviewOpts = {};
        peekDefinitionCode = {
          "<leader>df" = "@function.outer";
          "<leader>dF" = "@class.outer";
        };
      };

      move = {
        enable = true;

        setJumps = true; # whether to set jumps in the jumplist
        gotoNextStart = {
          "]m" = "@function.outer";
          "]]" = { query = "@class.outer"; desc = "next class start"; };

          # you can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
          "]o" = "@loop.*";
          # "]o" = { query = { "@loop.inner", "@loop.outer" } ;

          # You can pass a query group to use query from `queries/<lang>/<queryGroup>.scm file in your runtime path.
          # Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
          "]s" = { query = "@local.scope"; queryGroup = "locals"; desc = "Next scope"; };
          "]z" = { query = "@fold"; queryGroup = "folds"; desc = "Next fold"; };
        };
        gotoNextEnd = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        gotoPreviousStart = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        gotoPreviousEnd = {
          "[m" = "@function.outer";
          "[]" = "@class.outer";
        };
        # Below will go to either the start or the end, whichever is closer.
        # Use if you want more granular movements
        # Make it even more gradual by adding multiple queries and regex.
        gotoNext = {
          "]d" = "@conditional.outer";
        };
        gotoPrevious = {
          "[d" = "@conditional.outer";
        };
      };

      select = {
        enable = true;

        # Automatically jump forward to textobj, similar to targets.vim
        lookahead = true;

        keymaps = {
          # You can use the capture groups defined in textobjects.scm
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          # You can optionally set descriptions to the mappings (used in the desc parameter of
          # nvim_buf_set_keymap) which plugins like which-key display
          "ic" = { query = "@class.inner"; desc = "Select inner part of a class region"; };
          # You can also use captures from other query groups like `locals.scm`
          "as" = { query = "@local.scope"; queryGroup = "locals"; desc = "Select language scope"; };
        };

        # You can choose the select mode (default is charwise "v")
        #
        # Can also be a function which gets passed a table with the keys
        # * queryString: eg "@function.inner"
        # * method: eg "v" or "o"
        # and should return the mode ("v", "V", or "<c-v>") or a table
        # mapping queryStrings to modes.
        selectionModes = {
          "@parameter.outer" = "v"; # charwise
          "@function.outer" = "V"; # linewise
          "@class.outer" = "<c-v>"; # blockwise
        };

        # If you set this to `true` (default is `false`) then any textobject is
        # extended to include preceding or succeeding whitespace. Succeeding
        # whitespace has priority in order to act similarly to eg the built-in
        # `ap`.
        #
        # Can also be a function which gets passed a table with the keys
        # * queryString: eg "@function.inner"
        # * selectionMode: eg "v"
        # and should return true or false
        includeSurroundingWhitespace = true;
      };

      swap = {
        enable = true;
        swapNext = {
          "<leader>a" = "@parameter.inner";
        };
        swapPrevious = {
          "<leader>A" = "@parameter.inner";
        };
      };
    };
  };
}
