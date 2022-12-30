![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/m400/technitium?logo=docker&style=plastic)  ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/m400/technitium?logo=docker&style=plastic)  ![Docker Pulls](https://img.shields.io/docker/pulls/m400/technitium?logo=docker&style=plastic)  ![GitHub](https://img.shields.io/github/license/hm400/technitium-docker-build?logo=github&style=plastic) 

## Technitium DNS Multi-Architecture Image for AMD64, ARM64, and ARM
Technitium DNS Server - https://technitium.com/dns/ by Mr. Zare

To demo the web console  `docker run -p 5380:5380 m400/technitium`  point browser to `http://127.0.0.1:5380` or `http://<ip>:5380`

### The docker run command below will pull the correct architecture for your host.

`docker run -d --name technitium -p 53:53/udp -p 53:53/tcp -p 5380:5380 --hostname=technitium-dns -e DNS_SERVER_LOG_USING_LOCAL_TIME=true -e DNS_SERVER_DOMAIN=dns-server -v config:/app/config -v ssl:/etc/ssl -v logs:/app/config/logs m400/technitium:latest`

Above command maps ports 53 udp for dns and 53 tcp (in case dns response is greater than 512 bytes), port 5380 for web console, sets container hostname, sets DNS server to use local time for logs, sets Dns server domain,  three volumes are created `config` for server config, `ssl` for certficates and `logs` for logs.   

Note: SSL certificates must be in  PKCS #12 certificate (.pfx) format.

Available ports are 80, 443, and 853 for DNS-over-HTTPS and DNS-over-TLS connections. Port 67 for DHCP server and port 53443 for webconsole over TLS.

### Docker-compose example
```
version: '3.7'
services:
  dns-server:
    image: m400/technitium:latest
    hostname: dns-server
    # networks:  Create network and uncomment if connecting to another container (reverse proxy, etc..)
    # - technitium-network
    ports:
    - 53:53/udp
    - 53:53/tcp
    - 67:67/udp
    - 80:80/tcp
    - 443:443/tcp
    - 853:853/tcp
    - 5380:5380/tcp
    - 8053:8053/tcp 
    environment:
    - DNS_SERVER_LOG_USING_LOCAL_TIME=true
    - DNS_SERVER_DOMAIN=dns-server
    volumes:
    - data:/app/config
    - ssl:/etc/ssl
    - logs:/app/config/logs

    restart: unless-stopped
volumes:
  data:
  ssl:
  logs:
#networks:
  #technitium-network:
    #external: true
```

### Additional Information
1.) Any desired service ports can not be in use on the nic that will be running the container. Docker will bind the specfied container ports to the default interface. To bind to a different nic map it by providing the ip address in the port mapping like so  `-p 192.168.1.10:5380:5380` 

2.) Default time is in UTC. If logs need local time set `DNS_SERVER_LOG_USING_LOCAL_TIME=true`

3.) The container will set the Default DNS server name as the container ID. This will have to change after updating the container else service is broken. Set `DNS_SERVER_DOMAIN=dns-server` to prevent this.

4.) Backup entire Dns Server configuration by navigaing to Settings > General > Scroll to bottom > Backup settinngs

5.) If using `:latest` image update via docker-compose by simply running `docker-compose down` -> `docker image rm m400/technitium:latest` -> `docker-compose up -d`.
