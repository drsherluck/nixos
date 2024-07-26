{
  config,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Consolas:size=9";
        dpi-aware = "yes";
        pad = "10x0";
        term = "xterm-256color";
      };
      colors = {
        foreground = "f8f8f8";
        background = "17181f";
        regular0 = "17181f";
        bright0 = "808e9b";
        regular1 = "ff6b81";
        bright1 = "ff4757";
        regular2 = "55efc4";
        bright2 = "32ff7e";
        regular3 = "fffa65";
        bright3 = "fff200";
        regular4 = "60a3bc";
        bright4 = "a29bfe";
        regular5 = "cd84f1";
        bright5 = "fd79a8";
        regular6 = "1de9b6";
        bright6 = "b3e5fc";
        regular7 = "f8f8f8";
        bright7 = "efefef";
      };
    };
  };
}
