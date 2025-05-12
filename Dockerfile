# src/CommunicationControl/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish DevOpsProject/DevOpsProject.CommunicationControl.API.csproj -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

# Встановлюємо значення за замовчуванням для Redis
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

# Команда запуску
ENTRYPOINT ["dotnet", "DevOpsProject.CommunicationControl.API.dll"]