# modules/debug.nix
let
  kmapP = import ../lib/mkKeymap.nix { prefix = "Debug: "; };
  kmapPR = import ../lib/mkKeymap.nix { prefix = "Debug: "; raw = true; };
in
{
  programs.nixvim = {
    # Shows how to use the DAP plugin to debug your code.
    # https://nix-community.github.io/nixvim/plugins/dap/index.html
    plugins.dap = {
      enable = true;
    };

    # Creates a beautiful debugger UI
    plugins.dap-ui = {
      enable = true;

      # Set icons to characters that are more likely to work in every terminal.
      # Feel free to remove or use ones that you like more! :)
      # Don't feel like these are good choices.
      settings = {
        icons = {
          expanded = "▾";
          collapsed = "▸";
          current_frame = "*";
        };

        controls = {
          icons = {
            pause = "⏸";
            play = "▶";
            step_into = "⏎";
            step_over = "⏭";
            step_out = "⏮";
            step_back = "b";
            run_last = "▶▶";
            terminate = "⏹";
            disconnect = "⏏";
          };
        };
      };
    };

    # virtual text support
    # https://nix-community.github.io/nixvim/plugins/dap-virtual-text/index.html
    plugins.dap-virtual-text.enable = false;

    # Add your own debuggers here

    keymaps = [
      # Basic debugging keymaps, feel free to change to your liking!
      (kmapP  [ "<F5>"       "<cmd>DapContinue<CR>"          "Start/Continue"     ])
      (kmapP  [ "<F1>"       "<cmd>DapStepInto<CR>"          "Step Into"          ])
      (kmapP  [ "<F2>"       "<cmd>DapStepOver<CR>"          "Step Over"          ])
      (kmapP  [ "<F3>"       "<cmd>DapStepOut<CR>"           "Step Out"           ])
      (kmapP  [ "<leader>b"  "<cmd>DapToggleBreakpoint<CR>"  "Toggle [b]reakpoint"  ])
      (kmapPR [ "<leader>B"  ''
          function()
            require('dap').set_breakpoint(vim.fn.input '[B]reakpoint condition: ')
          end
        ''  "Set Breakpoint" ])
      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      (kmapPR [ "<F7>"  ''
          function()
            require('dapui').toggle()
          end
        ''  "See last session result." ])
    ];

    extraConfigLua = ''
      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
    '';
  };
}
