let
  mapP = import ../../../lib/mkKeymap.nix { prefix = "Debug: "; };
  mapPR = import ../../../lib/mkKeymap.nix { prefix = "Debug: "; raw = true; };
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

    # Add your own debuggers here

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      # Basic debugging keymaps, feel free to change to your liking!
      (mapP  [ "<F5>"       "<cmd>DapContinue<CR>"          "Start/Continue"     ])
      (mapP  [ "<F1>"       "<cmd>DapStepInto<CR>"          "Step Into"          ])
      (mapP  [ "<F2>"       "<cmd>DapStepOver<CR>"          "Step Over"          ])
      (mapP  [ "<F3>"       "<cmd>DapStepOut<CR>"           "Step Out"           ])
      (mapP  [ "<leader>b"  "<cmd>DapToggleBreakpoint<CR>"  "Toggle Breakpoint"  ])
      (mapPR [ "<leader>B"  ''
          function()
            require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end
        ''  "Set Breakpoint" ])
      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      (mapPR [ "<F7>"  ''
          function()
            require('dapui').toggle()
          end
        ''  "See last session result." ])
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfiglua
    extraConfigLua = ''
      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
    '';
  };
}
