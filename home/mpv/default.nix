{lib, ...}: {
  programs.mpv = {
    enable = true;
    catppuccin.enable = lib.mkForce false;
    config = {
      # profile = "gpu-hq";
      slang = "eng";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      dither-depth = "auto";
      correct-downscaling = "yes";
      linear-downscaling = "yes";
      sigmoid-upscaling = "yes";
      deband = "yes";
      gpu-api = "vulkan";
      vulkan-async-compute = "yes";
      vulkan-async-transfer = "yes";
      vulkan-queue-count = 1;
      hwdec = "auto";
      border = "no";
      msg-color = "yes";
      deinterlace = "no";
      cursor-autohide = 1000;
      video-sync = "display-resample";
      vo = "gpu-next";
      sub-blur = 0.4;
      sub-scale = 0.7;
      sub-margin-y = 60;
      sub-color = "#d6ffffff";
      sub-shadow-offset = 5.0;
      sub-font = "Lato Bold";
      sub-back-color = "#00000000";
      sub-border-color = "#266a678c";
      sub-shadow-color = "#00000000";
      sub-auto = "all";
      volume-max = 200;
      sub-fix-timing = "yes";
      audio-channels = "auto";
      blend-subtitles = "yes";
      sub-ass-override = "yes";
      audio-file-auto = "fuzzy";
      audio-pitch-correction = "yes";
      audio-normalize-downmix = "yes";
      demuxer-mkv-subtitle-preroll = "yes";
    };
  };
}
