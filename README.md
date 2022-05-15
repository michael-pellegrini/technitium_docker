![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/m400/technitium?logo=docker&style=plastic)  ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/m400/technitium?logo=docker&style=plastic)  ![Docker Pulls](https://img.shields.io/docker/pulls/m400/technitium?logo=docker&style=plastic)  ![GitHub](https://img.shields.io/github/license/hm400/technitium-docker-build?logo=github&style=plastic) 

## Technitium DNS Multi-Architecture Image for AMD64, ARM64, and ARM
Technitium DNS Server - https://technitium.com/dns/

To demo the web console  `docker run -p 5380:5380 m400/technitium`  point browser to `http://127.0.0.1:5380` or `http://<ip>:5380`

### The docker run command below will pull the correct architecture for your host.

`docker run -d --name technitium -p 53:53/udp -p 53:53/tcp -p 5380:5380 --hostname=technitium-dns -e DNS_SERVER_LOG_USING_LOCAL_TIME=true -e TZ=America/New_York -v config:/app/config -v ssl:/etc/ssl -v logs:/app/config/logs m400/technitium:latest`

Above command maps ports 53 udp for dns and 53 tcp (in case dns response is greater than 512 bytes), port 5380 for web console, sets DNS server to use local time (i.e. the time set by TZ variable), sets the timezone environmental variable. Three volumes are created `config` for server config, `ssl` for certficates and `logs` for logs.   

Note: SSL certificates must be in  PKCS #12 certificate (.pfx) format.

Available ports are 80, 443, and 853 for DNS-over-HTTPS and DNS-over-TLS connections. Port 67 for DHCP server and port 53443 for webconsole over TLS.

### Docker-compose example
```
version: '3.7'
services:
  dns-server:
    image: m400/technitium:latest
    hostname: technitium-dns
    #networks:  #Create network and uncomment if connecting to another container (reverse proxy, etc..)
    #- technitium-network
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
    - TZ=America/New_York
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
1.) Any required service ports can not be in use on the host/interface that will be running the container. Docker will bind the specfied container ports to the default interface. If an additional interface is available it can be mapped to the container by providing the ip address in the port mapping like so  `-p 192.168.1.10:5380:5380` 

2.) Default time is in UTC. If the the timezone variable is set "Use local logging" has to be enabled under settings -> logging -> Use Local Time. Check https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a list of timezones.

3.) The container will set the Default DNS server name as the container ID. This will have to change after updating the container image because changing the image creates a new container with a new ID. If not changed service will be broken. The solution is to set the hostname when creating the container and updating the DNS Server Domain Name using the web console (Settings -> General -> DNS Server Domain).

4.) The hostname is saved to the mapped volume and will persist after updating the container image. Simply run `docker-compose down` -> `docker image rm m400/technitium:latest` -> `docker-compose up -d`.

#### Settings tab with Hostname.
![screenshot](https://user-images.githubusercontent.com/47049792/100488543-d4704d00-30dc-11eb-9df2-953eda7c8195.png)
	
#### Settings tab with Default Container ID.
![screenshot](https://user-images.githubusercontent.com/47049792/100488561-fa95ed00-30dc-11eb-8b44-0327dd3d0cab.png)


