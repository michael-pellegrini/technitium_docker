FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
LABEL maintainer="michaelpellegrinimail@gmail.com"
LABEL version="5.1"
WORKDIR /app
ADD DnsServerPortable.tar.gz /app 
RUN tar -xjf /app/DnsServerPortable.tar.gz \
&& apt update && apt upgrade -y \
&& rm /app/DnsServerPortable.tar.gz
EXPOSE 5380
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
