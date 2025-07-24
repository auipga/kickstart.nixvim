{
  programs.nixvim = {
    # https://github.com/nvim-lualine/lualine.nvim
    # https://nix-community.github.io/nixvim/plugins/lualine/settings/index.html
    plugins.lualine.enable = true;
    plugins.lualine.settings = {
      options.theme = "ayu_dark";
      extensions = [
        # "aerial"
        # "assistant"
        # "avante"
        # "chadtree"
        # "ctrlspace"
        # "fern"
        # "fugitive"
        "fzf"
        # "lazy"
        # "man"
        # "mason"
        # "mundo"
        # "neo-tree"       # see ../../kickstart/plugins/neo-tree.nix
        # "nerdtree"
        # "nvim-dap-ui"
        # "nvim-tree"
        # "oil"
        # "overseer"
        "quickfix"
        # "symbols-outline"
        # "toggleterm"      # see ./terminal.nix
        # "trouble"         # see ./trouble.nix
      ];
      sections = {
        lualine_y.__raw = ''
          {
            -- see https://github.com/Davidyz/VectorCode/wiki/Neovim-Integrations#nvim-lualinelualinenvim
            require("vectorcode.integrations").lualine({
              show_job_count = true, -- default: false
            })
          }
        '';
      };
    };
  };
}
