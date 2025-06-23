let
  map = import ./lib/mkKeymap.nix { };
in
{
  programs.nixvim = {
    keymaps = [
      # shorter than the original "Opens filepath or URI under the cursor with the system handler (file explorer, web browser, ...)"
      (map [ "gx" ":lua OpenUrlUnderCursor()<CR>" "Open URL in browser" ])
    ];
  };
}
