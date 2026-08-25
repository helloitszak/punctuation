{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # set EDITOR
    defaultEditor = true;

    # As of 26.05 these are disabled by default.
    # I see no reason to turn them off so on they stay.
    withRuby = true;
    withPython3 = true;
  };
}
