# lib/mkPluginKeymaps.nix
argsList:
builtins.listToAttrs (
  builtins.map
    (
      args:
      let
        key = builtins.elemAt args 0;
        action = builtins.elemAt args 1;
        desc = if builtins.length args > 2 then builtins.elemAt args 2 else null;
        mode = if builtins.length args > 3 then builtins.elemAt args 3 else "n";
      in
      {
        name = key;
        value = { inherit action mode desc; };
      }
    )
    argsList
)
