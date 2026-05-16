# plugins/codecompanion/rules/nix.nix
{
  nixos = {
    description = "nixos-config";
    enabled.__raw = ''
      function()
        -- Don't show this group unless in a specific dir
        return vim.fn.getcwd():find("nixos-config", 1, true) ~= nil
      end
    '';
    # parser = "CodeCompanion";
    files = [
      ".codecompanion/rules/nix.md"
    ];
    is_preset = true;
  };
  nixvim = {
    description = "nixvim";
    files = [
      ".codecompanion/rules/nixvim.md"
    ];
    is_preset = true;
  };
}
