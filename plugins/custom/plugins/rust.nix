{ lib, ... }:
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
    };

    plugins.dap-ui = {
      enable = true;
    };

#    plugins.neotest.adapters.rust.enable = true;

    plugins.dap-lldb = { # C, C++, Rust
      enable = true;
      settings = {
        configurations = {
          # blindly copied from https://nix-community.github.io/nixvim/plugins/dap-lldb/settings.html#pluginsdap-lldbsettingsconfigurations
          rust = [
            {
              cwd = "$\${workspaceFolder}";
              name = "Debug";
              program = {
                __raw = ''
                  function(selection)
                     local targets = list_targets(selection)

                     if targets == nil then
                        return nil
                     end

                     if #targets == 0 then
                        return read_target()
                     end

                     if #targets == 1 then
                        return targets[1]
                     end

                     local options = { "Select a target:" }

                     for index, target in ipairs(targets) do
                        local parts = vim.split(target, sep, { trimempty = true })
                        local option = string.format("%d. %s", index, parts[#parts])
                        table.insert(options, option)
                     end

                     local choice = vim.fn.inputlist(options)

                     return targets[choice]
                  end
                '';
              };
              request = "launch";
              stopOnEntry = false;
              type = "lldb";
            }
            {
              args = {
                __raw = ''
                  function()
                     local args = vim.fn.input("Enter args: ")
                     return vim.split(args, " ", { trimempty = true })
                  end
                '';
              };
              cwd = "$\${workspaceFolder}";
              name = "Debug (+args)";
              program = {
                __raw = ''
                  function(selection)
                     local targets = list_targets(selection)

                     if targets == nil then
                        return nil
                     end

                     if #targets == 0 then
                        return read_target()
                     end

                     if #targets == 1 then
                        return targets[1]
                     end

                     local options = { "Select a target:" }

                     for index, target in ipairs(targets) do
                        local parts = vim.split(target, sep, { trimempty = true })
                        local option = string.format("%d. %s", index, parts[#parts])
                        table.insert(options, option)
                     end

                     local choice = vim.fn.inputlist(options)

                     return targets[choice]
                  end
                '';
              };
              request = "launch";
              stopOnEntry = false;
              type = "lldb";
            }
            {
              args = [
                "--test-threads=1"
              ];
              cwd = "$\${workspaceFolder}";
              name = "Debug tests";
              program = {
                __raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
              };
              request = "launch";
              stopOnEntry = false;
              type = "lldb";
            }
            {
              args = {
                __raw = ''
                  function()
                      return vim.list_extend(read_args(), { "--test-threads=1" })
                  end
                '';
              };
              cwd = "$\${workspaceFolder}";
              name = "Debug tests (+args)";
              program = {
                __raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
              };
              request = "launch";
              stopOnEntry = false;
              type = "lldb";
            }
            {
              args = {
                __raw = ''
                  function()
                    local test = select_test()
                    local args = test and { "--exact", test } or {}
                    return vim.list_extend(args, { "--test-threads=1" })
                  end
                '';
              };
              cwd = "$\${workspaceFolder}";
              name = "Debug tests (cursor)";
              program = {
                __raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
              };
              request = "launch";
              stopOnEntry = false;
              type = "lldb";
            }
            {
              cwd = "$\${workspaceFolder}";
              name = "Attach debugger";
              program = {
                __raw = ''
                  function()
                     local cwd = string.format("%s%s", vim.fn.getcwd(), sep)
                     return vim.fn.input("Path to executable: ", cwd, "file")
                  end
                '';
              };
              request = "attach";
              stopOnEntry = false;
              type = "lldb";
            }
          ];
        };
      };
    };

    # https://github.com/mrcjkb/rustaceanvim
    # https://nix-community.github.io/nixvim/plugins/rustaceanvim/index.html
    plugins.rustaceanvim.enable = false;

    plugins.lsp = {
      enable = true;
      ## servers OR rustaceanvim !
      servers = {
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };

    plugins.crates.enable = true;

    plugins.cmp.settings.sources = lib.mkAfter [
      { name = "crates"; }
    ];
  };
}
