FROM mcr.microsoft.com/dotnet/core/sdk:3.0

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get -y install docker-ce-cli nodejs \
    && apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false software-properties-common

ENV GITHUB_RUNNER_VERSION 2.161.0

RUN mkdir actions-runner && cd actions-runner \
    && curl -O https://githubassets.azureedge.net/runners/${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

WORKDIR /actions-runner
COPY cmd.sh /actions-runner/cmd.sh
RUN chmod +X /actions-runner/cmd.sh

CMD ["bash", "/actions-runner/cmd.sh"]