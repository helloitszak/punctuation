{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.ffmpeg-full.override { withUnfree = true; })
    mpv
    yt-dlp
    gallery-dl
    nmap
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
