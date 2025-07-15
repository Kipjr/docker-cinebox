# CineBox - Personal PVR with VPN

# CineBox

Combined repo of Nginx, Gluetun, Medusa, Radarr, Jackett, Emby and Transmission

### Instructions:

- Change docker-compose.yml with your values
- Emby
  - Leave as is
- Jackett
  - Edit `data/config/etc/jacket/Jackett/ServerConfig.json`
  - Modify to `"BasePathOverride": "/jackett"` so `/jackett` works as reverse proxy
- Medusa
  - Edit  `data/config/etc/medusa/config.ini`
  - `web_root=/medusa`
  - `handle_reverse_proxy = 1`
- Run `docker compose up -d --force-recreate` 
- From now on you should be able to access it using `http://<dockerHost>/`

### Environment

<!--__ACTION_DYNAMIC_ENV_START__-->

<!--__ACTION_DYNAMIC_ENV_STOP__-->

### Directory Structure:


#### Data

- data
  - config
    - etc
      - nginx
      - gluetun
      - ...
    - secrets
  - media
    - downloads/incomplete
    - downloads/complete
    - movies
    - series
  - logs



#### Test & Debug
- test/Dockerfile
- test/test.sh

<hr>

# GlueTun

<i>[README.md](https://github.com/qdm12/gluetun/blob/master/README.md)</i>

*Lightweight swiss-knife-like VPN client to tunnel to Cyberghost, ExpressVPN, FastestVPN,
HideMyAss, IPVanish, IVPN, Mullvad, NordVPN, Perfect Privacy, Privado, Private Internet Access, PrivateVPN,
ProtonVPN, PureVPN, Surfshark, TorGuard, VPNUnlimited, VyprVPN, WeVPN and Windscribe VPN servers
using Go, OpenVPN or Wireguard, iptables, DNS over TLS, ShadowSocks and an HTTP proxy*

## Features

- Based on Alpine 3.15 for a small Docker image of 29MB
- Supports: **Cyberghost**, **ExpressVPN**, **FastestVPN**, **HideMyAss**, **IPVanish**, **IVPN**, **Mullvad**, **NordVPN**, **Perfect Privacy**, **Privado**, **Private Internet Access**, **PrivateVPN**, **ProtonVPN**, **PureVPN**,  **Surfshark**, **TorGuard**, **VPNUnlimited**, **Vyprvpn**, **WeVPN**, **Windscribe** servers
- Supports OpenVPN for all providers listed
- Supports Wireguard both kernelspace and userspace
  - For **Mullvad**, **Ivpn** and **Windscribe**
  - For **Torguard**, **VPN Unlimited** and **WeVPN** using [the custom provider](https://github.com/qdm12/gluetun/wiki/Custom-provider)
  - For custom Wireguard configurations using [the custom provider](https://github.com/qdm12/gluetun/wiki/Custom-provider)
  - More in progress, see [#134](https://github.com/qdm12/gluetun/issues/134)
- DNS over TLS baked in with service provider(s) of your choice
- DNS fine blocking of malicious/ads/surveillance hostnames and IP addresses, with live update every 24 hours
- Choose the vpn network protocol, `udp` or `tcp`
- Built in firewall kill switch to allow traffic only with needed the VPN servers and LAN devices
- Built in Shadowsocks proxy (protocol based on SOCKS5 with an encryption layer, tunnels TCP+UDP)
- Built in HTTP proxy (tunnels HTTP and HTTPS through TCP)
- [Connect other containers to it](https://github.com/qdm12/gluetun/wiki/Connect-a-container-to-gluetun)
- [Connect LAN devices to it](https://github.com/qdm12/gluetun/wiki/Connect-a-LAN-device-to-gluetun)
- Compatible with amd64, i686 (32 bit), **ARM** 64 bit, ARM 32 bit v6 and v7, and even ppc64le 🎆
- [Custom VPN server side port forwarding for Private Internet Access](https://github.com/qdm12/gluetun/wiki/Private-internet-access#vpn-server-port-forwarding)
- Possibility of split horizon DNS by selecting multiple DNS over TLS providers
- Unbound subprogram drops root privileges once launched
- Can work as a Kubernetes sidecar container, thanks @rorph

## Setup

Go to the [Wiki](https://github.com/qdm12/gluetun/wiki)!

# nginx

Simple webserver to connect to the internal services

# Debug

Simple Ubuntu Image to check your network & VPN configuration
