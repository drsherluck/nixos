{pkgs, lib, ...}: {
  imports = [
    ./../modules/unbound-rules.nix
  ];

  services.resolved.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = ["127.0.0.1"];
    dhcpcd.extraConfig = ''
      nohook resolv.conf
      supersede domain-name-servers 127.0.0.1
    '';
    networkmanager.dns = "systemd-resolved";
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/networking/networkmanager.nix#L23
    # resolvconf.enable = false;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = lib.mkForce [];
    allowedUDPPorts = lib.mkForce [];
    # block all incoming external traffic from external interfaces (enp4s0 or wlp4s0)
    # allows container-to-container traffic
    extraCommands = ''
      iptables -N DOCKER-USER || true
      iptables -F DOCKER-USER
      iptables -A DOCKER-USER -i wl+ -m state --state RELATED,ESTABLISHED -j ACCEPT
      iptables -A DOCKER-USER -i en+ -m state --state RELATED,ESTABLISHED -j ACCEPT
      iptables -A DOCKER-USER -i wl+ -j DROP
      iptables -A DOCKER-USER -i en+ -j DROP
      iptables -A DOCKER-USER -j RETURN
      iptables -A nixos-fw -p tcp --source 192.168.0.0/16 --dport 1024:65535 -j nixos-fw-accept
    '';
  };

  services.unbound.enable = true;
  services.unbound.settings = {
    server = {
      verbosity = 0;
      log-queries = "no";
      use-syslog = "yes";
      prefetch = "yes";
      interface = ["127.0.0.1"];
      access-control = [];
      harden-glue = "yes";
      harden-dnssec-stripped = "yes";
      use-caps-for-id = "no";
      hide-identity = "yes";
      hide-version = "yes";
      do-ip4 = "yes";
      do-ip6 = "yes";
      do-udp = "yes";
      do-tcp = "yes";
      tls-upstream = "yes";
      deny-any = "yes";
      minimal-responses = "yes";
    };
    forward-zone = [
      {
        name = ".";
        forward-tls-upstream = "yes";
        forward-tcp-upstream = "yes";
        forward-first = "no";
        forward-addr = [
          "9.9.9.9@853#dns.quad9.net"
          "149.112.112.112@853#dns.quad9.net"
        ];
      }
    ];
  };

  unbound-rules = {
    enable = true;
    oisd-big = true;
  };
}
