FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Node.js is required by the PublishRunWebpack target to build the React ClientApp
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl gnupg ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .
RUN dotnet publish Requestrr.WebApi/Requestrr.WebApi.csproj -c Release -o /app/publish

# Matches the official image layout: app in /root, config in /root/config, port 4545
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /root
COPY --from=build /app/publish .
EXPOSE 4545
ENTRYPOINT ["dotnet", "Requestrr.WebApi.dll"]
