# ----------- STAGE 1: Build & Publish -------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy all .csproj files for all projects referenced in the solution
COPY SimpleWebApi/*.csproj ./SimpleWebApi/
COPY SimpleWebApi.Test/*.csproj ./SimpleWebApi.Test/
COPY *.sln ./

# Restore dependencies
RUN dotnet restore

# Copy everything else (code, tests, configs, etc.)
COPY . .

# Optional: Clear NuGet cache to prevent stale package issues
# RUN dotnet nuget locals all --clear

# Build and publish the main app (not test project)
WORKDIR /src/SimpleWebApi
RUN dotnet publish -c Release -o /app/publish

# ----------- STAGE 2: Runtime -------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8888

ENTRYPOINT ["dotnet", "SimpleWebApi.dll"]