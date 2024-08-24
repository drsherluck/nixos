{...}: {
  services.dunst = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "macchiato";
    };
    settings = {
      global = {
        history_length = 50;
        corner_radius = 5;
        frame_width = 2;
      };
    };
  };
}
