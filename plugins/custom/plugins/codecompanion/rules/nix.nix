{
  nix = {
    description = "nixos-config and nixvim";
    enabled.__raw = ''
      function()
        -- Don't show this group unless in a specific dir
        return vim.fn.getcwd():find("nixos-config", 1, true) ~= nil
      end
    '';
    # parser = "CodeCompanion";
    files = [
      ".codecompanion/rules/nix.md"
      ".codecompanion/rules/nixvim.md"
    ];
    is_preset = true;
  };
}
