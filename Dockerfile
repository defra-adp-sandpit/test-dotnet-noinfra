ARG PARENT_VERSION=1.7.0-dotnet8.0

# Development
FROM defradigital/dotnetcore-development:${PARENT_VERSION} AS development
ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/dotnetcore-development:${PARENT_VERSION}

COPY --chown=dotnet:dotnet ./Directory.Build.props ./Directory.Build.props
RUN mkdir -p /home/dotnet/src/Test.Dotnet.Noinfra.Api/
WORKDIR /home/dotnet/src
COPY --chown=dotnet:dotnet ./src/Test.Dotnet.Noinfra.Api/*.csproj ./Test.Dotnet.Noinfra.Api/
COPY --chown=dotnet:dotnet ./src/Test.Dotnet.Noinfra.Core/*.csproj ./Test.Dotnet.Noinfra.Core/
RUN dotnet restore "./Test.Dotnet.Noinfra.Core/Test.Dotnet.Noinfra.Core.csproj"
RUN dotnet restore "./Test.Dotnet.Noinfra.Api/Test.Dotnet.Noinfra.Api.csproj"

# some CI builds fail with back to back COPY statements, eg Azure DevOps
RUN true
COPY --chown=dotnet:dotnet ./src/Test.Dotnet.Noinfra.Api/ ./Test.Dotnet.Noinfra.Api/
COPY --chown=dotnet:dotnet ./src/Test.Dotnet.Noinfra.Core/ ./Test.Dotnet.Noinfra.Core/

RUN chown -R dotnet:dotnet /home/dotnet

WORKDIR /home/dotnet/src/Test.Dotnet.Noinfra.Api
RUN dotnet publish -c Release -o /home/dotnet/out

ARG PORT=3007
ENV PORT ${PORT}
EXPOSE ${PORT}
# Override entrypoint using shell form so that environment variables are picked up
ENTRYPOINT dotnet watch --project Test.Dotnet.Noinfra.Api.csproj run --urls "http://*:${PORT}"

# Production
FROM defradigital/dotnetcore:${PARENT_VERSION} AS production
ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/dotnetcore:${PARENT_VERSION}
COPY --from=development /home/dotnet/out/ ./
ARG PORT=3007
ENV ASPNETCORE_URLS http://*:${PORT}
EXPOSE ${PORT}
# Override entrypoint using shell form so that environment variables are picked up
ENTRYPOINT dotnet Test.Dotnet.Noinfra.Api.dll
