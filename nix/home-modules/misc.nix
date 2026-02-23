{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ffmpeg
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
