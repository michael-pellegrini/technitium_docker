FROM mcr.microsoft.com/dotnet/aspnet:5.0.5
LABEL maintainer="michaelpellegrini@protonmail.com"
LABEL version="6.4"

ENV TZ=America/New_York

WORKDIR /app

RUN apt-get update; apt-get upgrade-dist -y; apt-get install curl -y; apt-get clean -y; apt-get autoremove -y; \
curl https://download.technitium.com/dns/DnsServerPortable.tar.gz --output DnsServerPortable.tar.gz; \
gunzip /app/DnsServerPortable.tar.gz; \
tar -xf /app/DnsServerPortable.tar; \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; echo $TZ > /etc/timezone; \
rm /app/DnsServerPortable.tar

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 853/tcp
EXPOSE 5380

VOLUME [ "/app/config" ]
VOLUME [ "/etc/ssl" ]
VOLUME [ "/app/config/logs" ]

ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
