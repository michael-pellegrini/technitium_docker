FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
LABEL maintainer="michaelpellegrinimail@gmail.com"
LABEL version="5.5"
WORKDIR /app
ADD DnsServerPortable.tar.gz /app 
RUN apt update && apt upgrade -y 
EXPOSE 5380
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
ENTRYPOINT [ "dotnet", "/app/DnsServerApp.dll" ]
