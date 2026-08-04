{pkgs, ...}: {
  home.packages = with pkgs; [
    unstablePkgs.ffmpeg-full
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
