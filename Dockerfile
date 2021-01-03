FROM mcr.microsoft.com/dotnet/aspnet:5.0
LABEL maintainer="michaelpellegrinimail@gmail.com"
LABEL version="5.6"
WORKDIR /app
RUN apt update; apt upgrade -y; apt install curl -y; \
curl https://download.technitium.com/dns/DnsServerPortable.tar.gz --output DnsServerPortable.tar.gz; \
gunzip /app/DnsServerPortable.tar.gz; \
tar -xf /app/DnsServerPortable.tar; \
rm /app/DnsServerPortable.tar 
EXPOSE 5380
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
VOLUME [ "/app/config" ]
ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
