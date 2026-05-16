# plugins/codecompanion/rules/hardware.nix
{
  hardware = {
    description = "[my hardware]";
    enabled = true;
    # parser = "CodeCompanion";
    files = {
      "pc" = {
        description = "My PC specs";
        files = [
          "~/.rules/hardware/default.md"
          "~/.rules/hardware/pc.md"
        ];
      };
      "pc-next" = {
        description = "The next PC";
        files = [
          "~/.rules/hardware/default.md"
          "~/.rules/hardware/pc-next.md"
        ];
      };
      "steamdeck" = {
        description = "My Steam Deck";
        files = [
          "~/.rules/hardware/default.md"
          "~/.rules/hardware/steamdeck.md"
        ];
      };
      "peripherals" = {
        description = "My peripherals";
        files = [
          "~/.rules/hardware/default.md"
          "~/.rules/hardware/peripherals.md"
        ];
      };
      "spare" = {
        description = "My spare hardware";
        files = [
          "~/.rules/hardware/default.md"
          "~/.rules/hardware/spare.md"
        ];
      };
    };
    is_preset = true;
  };
}
