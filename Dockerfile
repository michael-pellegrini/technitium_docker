FROM mcr.microsoft.com/dotnet/runtime:6.0
LABEL maintainer="michaelpellegrini@protonmail.com"

ENV TZ=America/New_York

WORKDIR /app

RUN apt-get update; apt-get install curl -y; apt-get clean -y; \
curl https://download.technitium.com/dns/DnsServerPortable.tar.gz --output DnsServerPortable.tar.gz; \
gunzip /app/DnsServerPortable.tar.gz; \
tar -xf /app/DnsServerPortable.tar; \
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; \ 
rm /app/DnsServerPortable.tar

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 853/tcp
EXPOSE 5380/tcp
EXPOSE 8053/tcp

VOLUME [ "/app/config" ]
VOLUME [ "/etc/ssl" ]
VOLUME [ "/app/config/logs" ]

ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
