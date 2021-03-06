FROM tcardonne/github-runner:latest

USER root

RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get -y install docker-ce-cli nodejs build-essential \
    && apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false software-properties-common

ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetCoreSDK-Debian-10

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu63 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
RUN dotnet_sdk_version=3.1.300 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='1c3844ea5f8847d92372dae67529ebb08f09999cac0aa10ace571c63a9bfb615adbf8b9d5cebb2f960b0a81f6a5fba7d80edb69b195b77c2c7cca174cbc2fd0b' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help