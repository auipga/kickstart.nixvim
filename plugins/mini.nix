{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://github.com/nvim-mini/mini.nvim/
    # https://nix-community.github.io/nixvim/plugins/mini/index.html
    plugins.mini = {
      enable = true;

      # https://nix-community.github.io/nixvim/plugins/mini/index.html#pluginsminimodules
      modules = {
        # Better Around/Inside textobjects
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-ai.md
        # Examples:
        #  - va)  - [V]isually select [A]round [)]paren
        #  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        #  - ci'  - [C]hange [I]nside [']quote
        ai = {
          n_lines = 100; # 50
          search_method = "cover_or_next";
        };

        # Align text interactively
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-align.md
        align = {
          # :h MiniAlign-modifiers-builtin
          # :h MiniAlign-examples
        };

        # Tweak and save any color scheme
        # (also installs colorschemes mini[spring|summer|autumn|winter], minicyan, minischeme, randomhue)
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-colors.md
        # colors = {}
        # Run with :lua require('mini.colors').interactive()

        # Comment lines
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-comment.md
        # comment = {
        #   mappings = {
        #     comment = "<leader>/";
        #     comment_line = "<leader>/";
        #     comment_visual = "<leader>/";
        #     textobject = "<leader>/";
        #   };
        # };
        # INFO: I use the built-in commenting for now (:h commenting)

        # Automatic highlighting of word under cursor
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-cursorword.md
        cursorword = {
          delay = 500;
        };

        # Highlight patterns in text
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hipatterns.md
        hipatterns = {
          highlighters = {
            # Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]"; group = "MiniHipatternsFixme"; };
            todo  = { pattern = "%f[%w]()TODO()%f[%W]";  group = "MiniHipatternsTodo";  };
            hack  = { pattern = "%f[%w]()HACK()%f[%W]";  group = "MiniHipatternsHack";  };
            note  = { pattern = "%f[%w]()NOTE()%f[%W]";  group = "MiniHipatternsNote";  };

            # Highlight hex color strings (`#rrggbb`) using that color
            hex_color.__raw = ''
              require('mini.hipatterns').gen_highlighter.hex_color()
            '';
          };
        };

        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-icons.md#demo
        icons = {};

        # Extend f, F, t, T to work on multiple lines + repeat + highlight + dot
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-jump.md
        jump = {};

        # Jump to exact location on screen using abc
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-jump2d.md
        jump2d = {
          view.dim = true;
          allowed_windows.not_current = false;
          mappings.start_jumping = "<leader><CR>";
          silent = true;
        };

        # Move any selection in any direction
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-move.md
        move = {
          # Default keymaps: Alt (Meta) + hjkl
        };

        # Minimal and fast autopairs
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pairs.md
        # pairs = {};
        # INFO: replaced by ../plugins/kickstart/plugins/autopairs.nix

        # Pick anything
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pick.md
        # pick = {};

        # Manage and expand snippets
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-snippets.md
        # TODO: checkout, needed at all?
        # snippets = {};

        # Split and join arguments
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-splitjoin.md
        # Default keymap: gS to toggle
        splitjoin = {};
        # INFO:
        # for Rust maybe use https://github.com/AndrewRadev/splitjoin.vim
        # it can expand ? to match Ok/Err :+1:

        # Add/delete/replace surroundings (brackets, quotes, etc.)
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md
        #
        # Examples:
        #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        #  - sd'   - [S]urround [D]elete [']quotes
        #  - sr)'  - [S]urround [R]eplace [)] [']
        #  - s[add|delete|find|Find_left|highlight|replace]
        # surround = {
        #   highlight_duration = 1500;
        #   n_lines = 100; # 20
        # };
        # replaces surround.nvim # see ./custom/plugins/surround.nix

        # Simple and easy statusline.
        #  You could remove this setup call if you don't like it,
        #  and try some other statusline plugin
        # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-statusline.md
        # statusline = {
        #   use_icons.__raw = "vim.g.have_nerd_font";
        # };

        # ... and there is more!
        # Check out: https://github.com/nvim-mini/mini.nvim
        # https://github.com/nvim-mini/mini.nvim/blob/main/README.md
      };
    };

    # You can configure sections in the statusline by overriding their
    # default behavior. For example, here we set the section for
    # cursor location to LINE:COLUMN
    extraConfigLua = ''
      -- require('mini.statusline').section_location = function()
      --   return '%2l:%-2v'
      -- end
    '';
  };
}
