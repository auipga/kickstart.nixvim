{
  imports = [
    ./hmts.nix

    # LSP servers (select only one!)
    # ./nil_ls.nix # if you want stability and formatting (better support for nixpkgs-fmt and nixfmt).
    ./nixd.nix # if you want better autocompletion and deeper Nix evaluation support.

    ./nix-develop.nix
    ./vim-nix.nix
  ];
}
