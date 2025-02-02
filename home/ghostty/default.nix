{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    settings = {
      clipboard-trim-trailing-spaces = true;
      cursor-invert-fg-bg = true;
      cursor-style = "bar";
      cursor-style-blink = true;
      font-family = "Consolas Nerd Fonts";
      font-size = 7.8;
      gtk-adwaita = false;
      gtk-titlebar = false;
      link-url = true;
      mouse-hide-while-typing = true;
      window-decoration = false;
      window-padding-color = "extend";
      window-padding-x = 6;
      window-padding-y = 0;
      window-theme = "dark";
      background = "17181f";
      # normally f8f8f8, but scaling is different than alacritty
      # the high contrast is not that great for the eyes
      foreground = "f0f0f0";
      palette = [
        "0=17181f"
        "1=ff6b81"
        "2=55efc4"
        "3=fffa65"
        "4=60a3bc"
        "5=cd84f1"
        "6=1de9b6"
        "7=f8f8f8"
        "8=808e9b"
        "9=ff4757"
        "10=32ff7e"
        "11=fff200"
        "12=a29bfe"
        "13=fd79a8"
        "14=b3e5fc"
        "15=efefef"
      ];
    };
  };
}
