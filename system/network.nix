{
  lib,
  ...
}: {
  imports = [
    ./../modules/unbound-rules.nix
  ];

  networking = {
    nameservers = ["127.0.0.1"];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      connectionConfig = {
        "ipv4.ignore-auto-dns" = "1";
        "ipv6.ignore-auto-dns" = "1";
      };
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = lib.mkForce [];
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
      # Trust the local LAN (RFC1918) on high ports, TCP + UDP, private source IPs only.
      # UDP is required for Steam Remote Play / Steam Link discovery (UDP 27031-27036).
      iptables -A nixos-fw -p tcp --source 192.168.0.0/16 --dport 1024:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --source 10.0.0.0/8     --dport 1024:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --source 172.16.0.0/12  --dport 1024:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 192.168.0.0/16 --dport 1024:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 10.0.0.0/8     --dport 1024:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 172.16.0.0/12  --dport 1024:65535 -j nixos-fw-accept
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
    oisd-nsfw = true;
    safesearch = true;
  };
}
