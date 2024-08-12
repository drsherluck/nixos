{lib, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      cursor = {
        blink_timeout = 0;
        style.blinking = "Always";
      };
      font = {
        size = 9;
        normal.family = "Consolas Nerd Font";
      };
      window.padding = {
        x = 6;
        y = 0;
      };
      env = {
        WINIT_X11_SCALE_FACTOR = "1.0"; # Disable HiDPI
      };
      colors = lib.mkDefault {
        bright = {
          black = "0x808e9b";
          blue = "0xa29bfe";
          cyan = "0xb3e5fc";
          green = "0x32ff7e";
          magenta = "0xfd79a8";
          red = "0xff4757";
          white = "0xefefef";
          yellow = "0xfff200";
        };
        normal = {
          black = "0x17181f";
          blue = "0x60a3bc";
          cyan = "0x1de9b6";
          green = "0x55efc4";
          magenta = "0xcd84f1";
          red = "0xff6b81";
          white = "0xf8f8f8";
          yellow = "0xfffa65";
        };
        primary = {
          background = "0x17181f";
          foreground = "0xf8f8f8";
        };
      };
    };
  };
}
