FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
LABEL maintainer="michaelpellegrinimail@gmail.com"
LABEL version="5.5"
WORKDIR /app
RUN apt update && apt upgrade -y \
&& curl https://download.technitium.com/dns/DnsServerPortable.tar.gz --output DnsServerPortable.tar.gz \
&& gunzip /app/DnsServerPortable.tar.gz \
&& tar -xf /app/DnsServerPortable.tar \
&& rm /app/DnsServerPortable.tar 
EXPOSE 5380
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
