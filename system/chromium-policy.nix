_: {
  # https://lokcon.me/2020/05/03/stop-chrome-mdns
  environment.etc."chromium/policies/managed/default.json" = {
    enable = true;
    text = ''
      { "EnableMediaRouter": false, "ExtensionManifestV2Availability": 2 }
    '';
  };
}
