FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy all files from the build context (assumed to be src/CommunicationControl)
# This includes the HiveMind project and any other necessary solution/project files.
COPY . .

# Publish the Hive Mind API project
# Adjust the path to the .csproj file if your structure is different.
RUN dotnet publish ./DevOpsProject.HiveMind.API/DevOpsProject.HiveMind.API.csproj -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/out ./

# Set environment variables
# ASPNETCORE_ENVIRONMENT should be overridden to "Production" in your deployment environment
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Development

# Expose the port the application will run on
EXPOSE 8080

# Define the entry point for the application
ENTRYPOINT ["dotnet", "DevOpsProject.HiveMind.API.dll"]