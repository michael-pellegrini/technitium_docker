## Technitium DNS Multi-Architecture Image for AMD64, ARM64, and ARM
Technitium is a great Web based DNS/DHCP server - https://technitium.com/dns/

Version 5.2

Technitium DNS Server is an open source tool that can be used for self hosting a local DNS server for privacy & security or, used for experimentation/testing by software developers on their computer. It works out-of-the-box with no or minimal configuration and provides a user friendly web console accessible using any web browser.

### The docker run command below will pull the correct architecture (amd64,arm64,arm32) for your host.

`docker run -d --name technitium -p 53:53/udp -p 53:53/tcp -p 67:67/udp -p 5380:5380 -v data:/app/config m400/technitium`

or by version number  

`docker run -d --name technitium -p 53:53/udp -p 53:53/tcp -p 67:67/udp -p 5380:5380 -v data:/app/config m400/technitium:5.2`

Above command maps ports 53 udp and tcp for dns, port 67 udp for built-in dhcp server, port 5380 for web interface, creates a volume named data. 

#### Default username 'admin' and password 'admin'

### Docker-compose example
```
version: '3.5'
services:
  dns_server:
    image: m400/technitium
    networks:
      technitium-network:
        aliases:
          - technitium-dns
    ports:
    - 53:53/udp
    - 53:53/tcp
    - 67:67/udp
    - 5380:5380
    environment:
    - PUID=1000                  #https://docs.docker.com/engine/security/userns-remap/
    - PGID=1000
    volumes:
    - data:/app/config
    restart: unless-stopped
volumes:
  data:
networks:
  technitium-network:

```

### Additional Information
1.) Ports 53, 67 and 5380 should not be in use on the host running the container. Docker will bind the container to those ports.

2.) If the container ID changes the zone/records will point to the previous container ID that does not exist, this will require a manual change to resolve.
Alternativly a user-defined network with an alias can be set. After initializing the container, log in via the web interface, click settings tab and change "DNS Server Domain" to `technitium-dns`. The alias is specified in the docker-compose file and will be applied to all zones/records going forward.
	

![screenshot](https://user-images.githubusercontent.com/47049792/89482326-a3ec5800-d767-11ea-96c9-f87e3412ded3.jpeg)

