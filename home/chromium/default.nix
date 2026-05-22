_: {
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # youtube dislike
      {id = "hlepfoohegkhhmjieoechaddaejaokhf";} # refined github
      {id = "jghecgabfgfdldnmbfkhmffcabddioke";} # volume master
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "khncfooichmfjbepaaaebmommgaepoid";} # unhook
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
    ];
    commandLineArgs = [
      "--enable-gpu"
      "--disable-features=MediaRouter" # disable mDNS
      "--enable-features=UseOzonePlatform"
      "--enable-features=AcceleratedVideoDecodeLinuxGL"
      "--enable-features=AcceleratedVideoEncoder"
      "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--disable-gpu-compositing"
      # "--ozone-platform=wayland"
    ];
  };
}
