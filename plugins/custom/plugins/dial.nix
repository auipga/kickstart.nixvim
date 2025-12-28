let
  mapR = import ../../../lib/mkKeymap.nix { raw = true; extraOpts = { noremap = true; }; };
in
{
  programs.nixvim = {
    # Extended increment/decrement
    # https://github.com/monaqa/dial.nvim
    # https://nix-community.github.io/nixvim/plugins/dial/index.html
    # Alternatives:
    # 1k  https://github.com/monaqa/dial.nvim
    # 756 https://github.com/AndrewRadev/switch.vim
    # 72  https://github.com/rmagatti/alternate-toggler
    # 20  https://github.com/gerazov/toggle-bool.nvim (2 https://github.com/gerazov/vim-toggle-bool)
    # 5   https://github.com/johmsalas/shake.nvim
    plugins.dial.enable = true;
    plugins.dial.luaConfig.post = ''
      -- https://github.com/monaqa/dial.nvim#list-of-augends
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {                              -- try here:
          augend.integer.alias.decimal_int,      -- -1
          augend.integer.alias.hex,              -- 0x00, 0x1a21
          augend.date.alias["%d.%m.%y"],         -- 28.02.22
          augend.date.alias["%d.%m.%Y"],         -- 28.02.2022
          augend.date.alias["%Y/%m/%d"],         -- 2022/02/28
          augend.date.alias["%H:%M"],            -- 23:59
          augend.date.alias["%H:%M:%S"],         -- 23:59:59
          augend.constant.alias.de_weekday,      -- Mo
          augend.constant.alias.de_weekday_full, -- Montag
          augend.constant.alias.en_weekday,      -- Mon
          augend.constant.alias.en_weekday_full, -- Monday
          augend.constant.alias.bool,            -- true
          augend.constant.alias.Bool,            -- True
          augend.semver.alias.semver,            -- v0.2.1
          augend.misc.alias.markdown_header,     -- ## works at beginning of lines only
          -- augend.paren.alias.quote,              -- "foo"
          -- augend.paren.alias.brackets,           -- [ foo ] () {}
          -- augend.paren.alias.rust_str_literal,   -- r##"foo"##

          augend.hexcolor.new{                   -- #1A1A1A, #eeFEFE, #55Ff00 #1fF0a0 #909090
            case = "prefer_upper",
          },
          -- augend.constant.new{                   -- try on hexcolor case above
          --   elements = { "upper", "prefer_upper", "prefer_lower", "lower" },
          --   cyclic = false,
          -- },
        },
      }
    '';

    keymaps = [
      (mapR [ "<C-a>"  ''require("dial.map").inc_normal()''  "Increment"  ])
      (mapR [ "<C-x>"  ''require("dial.map").dec_normal()''  "Decrement"  ])
    ];
  };
}
