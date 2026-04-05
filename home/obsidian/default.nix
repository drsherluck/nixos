{...}: {
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      appearance = {
        cssTheme = "Minimal";
        theme = "obsidian";
        textFontFamily = "IBM Plex Mono";
        interfaceFontFamily = "IBM Plex Mono";
        monospaceFontFamily = "IBM Plex Mono";
      };
      themes = [
        "Minimal"
      ];
      communityPlugins = [
        "Minimal Theme Settings"
        "Auto Template Trigger"
        "Doubleshift"
      ];
    };
  };
}
