_: {
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
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
      # "--enable-features=UseOzonePlatform"
      # "--ozone-platform=wayland"
    ];
  };
}
