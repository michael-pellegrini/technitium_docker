FROM mcr.microsoft.com/dotnet/aspnet:7.0
LABEL maintainer="michaelpellegrini@protonmail.com"

ENV TZ=America/New_York

WORKDIR /app

RUN apt-get update; apt-get install curl -y; \
curl https://download.technitium.com/dns/DnsServerPortable.tar.gz --output DnsServerPortable.tar.gz; \
curl https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb --output packages-microsoft-prod.deb; \
gunzip /app/DnsServerPortable.tar.gz; tar -xf /app/DnsServerPortable.tar; \
dpkg -i packages-microsoft-prod.deb; apt-get update; apt install libmsquic=2.1.8 -y;  apt-get clean -y; \
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; rm DnsServerPortable.tar packages-microsoft-prod.deb 

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 443/udp
EXPOSE 853/tcp
EXPOSE 853/udp
EXPOSE 5380/tcp
EXPOSE 8053/tcp
EXPOSE 53443/tcp

VOLUME [ "/app/config" ]
VOLUME [ "/etc/ssl" ]
VOLUME [ "/app/config/logs" ]

ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
