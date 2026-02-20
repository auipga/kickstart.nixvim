{
  network = {
    description = "[my network]";
    enabled = true;
    # parser = "CodeCompanion";
    files = {
      "internet" = {
        description = "My internet";
        files = [ "~/.rules/network/internet.md" ];
      };
      "router" = {
        description = "My router";
        files = [ "~/.rules/network/router.local.md" ];
      };
      "router-next" = {
        description = "The next router";
        files = [ "~/.rules/network/router-next.md" ];
      };
    };
    is_preset = false;
  };
}
