{lib, ...}: {
  imports = [
    ./../modules/unbound-rules.nix
  ];

  # disable resolv and point to local dns resolver
  networking = {
    networkmanager.enable = true;
    nameservers = ["127.0.0.1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
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
    '';
  };

  unbound-rules = {
    enable = true;
    oisd-nsfw = false;
    oisd-big = true;
    safesearch = false;
    youtube = false;
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        verbosity = 0;
        use-syslog = "yes";
        prefetch = "yes";
        interface = ["127.0.0.1"];
        access-control = [];
        do-ip4 = "yes";
        do-ip6 = "yes";
        do-udp = "yes";
        do-tcp = "yes";
        tls-upstream = "yes";
        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
        deny-any = "yes";
        minimal-responses = "yes";
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = "yes";
          forward-addr = [
            #"1.1.1.1@853#cloudflare-dns.com"
            #"1.0.0.1@853#cloudflare-dns.com"
            "9.9.9.9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
          ];
        }
      ];
    };
  };

  services.resolved.enable = lib.mkForce false;
}
