# lib/mkKeymap.nix
{ prefix ? "", raw ? false }:

args:
let
  key = builtins.elemAt args 0;
  action = builtins.elemAt args 1;
  desc = if builtins.length args > 2 then builtins.elemAt args 2 else null;
  mode = if builtins.length args > 3 then builtins.elemAt args 3 else "n";
  extraOptions = if builtins.length args > 4 then builtins.elemAt args 4 else {};

  formattedDesc =
    if desc == null then null else prefix + desc;

  options = extraOptions // {
    desc = formattedDesc;
  };
in
{
  inherit key mode options;
  action = if raw then { __raw = action; } else action;
}
