# ----------- STAGE 1: Build & Publish -------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY *.sln .
COPY SimpleWebApi/*.csproj ./SimpleWebApi/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the code and publish
COPY SimpleWebApi/. ./SimpleWebApi/
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