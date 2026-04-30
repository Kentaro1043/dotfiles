# Gemini CLI Sandbox Image
# ref: https://github.com/google-gemini/gemini-cli/blob/main/Dockerfile

FROM docker.io/library/node:20 AS builder

ARG CLI_VERSION_ARG
ENV CLI_VERSION_GIT="v${CLI_VERSION_ARG}"

WORKDIR /build

RUN git clone -b "${CLI_VERSION_GIT}" --depth 1 https://github.com/google-gemini/gemini-cli.git .

RUN npm install \
  && npm run build --workspaces

RUN mkdir -p /build/artifacts \
  && npm pack -w @google/gemini-cli-core --pack-destination /build/artifacts \
  && npm pack -w @google/gemini-cli --pack-destination /build/artifacts

FROM docker.io/library/node:20-slim

ARG SANDBOX_NAME="gemini-cli-sandbox"
ARG CLI_VERSION_ARG
ENV SANDBOX="$SANDBOX_NAME"
ENV CLI_VERSION=$CLI_VERSION_ARG

# install minimal set of packages, then clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  make \
  g++ \
  man-db \
  curl \
  dnsutils \
  less \
  jq \
  bc \
  gh \
  git \
  unzip \
  rsync \
  ripgrep \
  procps \
  psmisc \
  lsof \
  socat \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# set up npm global package folder under /usr/local/share
# give it to non-root user node, already set up in base image
RUN mkdir -p /usr/local/share/npm-global \
  && chown -R node:node /usr/local/share/npm-global
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# switch to non-root user node
USER node

# install gemini-cli and clean up
COPY --from=builder /build/artifacts/*.tgz /tmp/artifacts/
RUN npm install -g /tmp/artifacts/google-gemini-cli-core-*.tgz \
  && npm install -g /tmp/artifacts/google-gemini-cli-*.tgz \
  && gemini --version > /dev/null \
  && npm cache clean --force

# default entrypoint when none specified
CMD ["gemini"]
