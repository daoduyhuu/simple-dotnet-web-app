# 1. Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY simple-dotnet-web-app.sln ./
COPY SimpleWebApi/SimpleWebApi.csproj SimpleWebApi/
COPY SimpleWebApi.Test/SimpleWebApi.Test.csproj SimpleWebApi.Test/

# Restore all projects in the solution
RUN dotnet restore simple-dotnet-web-app.sln

# Copy all source files
COPY SimpleWebApi/. SimpleWebApi/
COPY SimpleWebApi.Test/. SimpleWebApi.Test/

# Build and publish the main app
WORKDIR /src/SimpleWebApi
RUN dotnet publish -c Release -o /app/out

# 2. Runtime stage (only app code, not test code)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

EXPOSE 80
ENTRYPOINT ["dotnet", "SimpleWebApi.dll"]