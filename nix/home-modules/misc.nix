{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs-unstable.ffmpeg-full.override { withUnfree = true; })
    mpv
    yt-dlp
    gallery-dl
    nmap
    aria2
  ];
  #   nmap
  #   aria2
  #   yt-dlp
  #   mpv
  #   yt-dlp
  #   kubectl
  #   krew
  #   cmake
  #   local.proxmark3-rrg
  #   sshpass
  #   delta
  # ];
}
