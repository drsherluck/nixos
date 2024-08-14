{lib, ...}: {
  imports = [
    ./../modules/unbound-rules.nix
  ];

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;

    # disable resolv and point to local dns resolver
    nameservers = ["127.0.0.1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  unbound-rules = {
    enable = true;
    oisd-nsfw = true;
    oisd-big = true;
    safesearch = true;
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        verbosity = 0; # log errors only
        use-syslog = "yes";
        prefetch = "yes";
        interface = ["127.0.0.1"];
        access-control = ["127.0.0.1/8 allow"];
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
      remote-control.control-enable = true;
    };
  };

  services.resolved.enable = lib.mkForce false;
}
