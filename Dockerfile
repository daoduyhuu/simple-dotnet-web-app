# ----------- STAGE 1: Build & Publish -------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files first
COPY SimpleWebApi/*.csproj ./SimpleWebApi/
COPY *.sln ./

# Restore dependencies
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Build and publish
WORKDIR /src/SimpleWebApi
RUN dotnet publish -c Release -o /app/publish --no-restore

# ----------- STAGE 2: Runtime -------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

# Optional: expose port (adjust based on your app's settings)
EXPOSE 80

# Entry point
ENTRYPOINT ["dotnet", "SimpleWebApi.dll"]