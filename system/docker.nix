{...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    # default bind address in 127.0.0.1
    # not respected by compose or swarm
    daemon.settings = {
      ip = "127.0.0.1";
    };
  };
}
