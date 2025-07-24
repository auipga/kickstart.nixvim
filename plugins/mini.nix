{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/mini/index.html
    plugins.mini = {
      enable = true;

      # https://nix-community.github.io/nixvim/plugins/mini/index.html#pluginsminimodules
      modules = {
        # Better Around/Inside textobjects
        # https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
        # Examples:
        #  - va)  - [V]isually select [A]round [)]paren
        #  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        #  - ci'  - [C]hange [I]nside [']quote
        ai = {
          n_lines = 100; # 50
          search_method = "cover_or_next";
        };

        # Add/delete/replace surroundings (brackets, quotes, etc.)
        # https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
        #
        # Examples:
        #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        #  - sd'   - [S]urround [D]elete [']quotes
        #  - sr)'  - [S]urround [R]eplace [)] [']
        surround = {
          highlight_duration = 1500;
          n_lines = 100; # 20
        };

        # Simple and easy statusline.
        #  You could remove this setup call if you don't like it,
        #  and try some other statusline plugin
        # https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
        # statusline = {
        #   use_icons.__raw = "vim.g.have_nerd_font";
        # };

        # ... and there is more!
        # Check out: https://github.com/echasnovski/mini.nvim
        # https://github.com/echasnovski/mini.nvim/blob/main/README.md
      };
    };

    # You can configure sections in the statusline by overriding their
    # default behavior. For example, here we set the section for
    # cursor location to LINE:COLUMN
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfiglua
    extraConfigLua = ''
      require('mini.statusline').section_location = function()
        return '%2l:%-2v'
      end
    '';
  };
}
