FROM node:18.14

RUN apt-get update && apt-get install -y curl jq && apt-get -y clean && rm -rf /var/lib/apt/lists/* \
  && export FASTLY_CLI_VERSION=$(curl -s https://api.github.com/repos/fastly/cli/releases/latest | jq -r .tag_name | cut -d 'v' -f 2) \
            GOARCH=$(dpkg --print-architecture) \
  && curl -sL "https://github.com/fastly/cli/releases/download/v${FASTLY_CLI_VERSION}/fastly_v${FASTLY_CLI_VERSION}_linux-$GOARCH.tar.gz" -o fastly.tar.gz \
  && curl -sL "https://github.com/fastly/cli/releases/download/v${FASTLY_CLI_VERSION}/fastly_v${FASTLY_CLI_VERSION}_SHA256SUMS" -o sha256sums \
  && dlsha=$(shasum -a 256 fastly.tar.gz | cut -d " " -f 1) && expected=$(cat sha256sums | awk -v pat="$dlsha" '$0~pat' | cut -d " " -f 1) \
  && if [ "$dlsha" != "$expected" ]; then echo "shasums don't match" && exit 1; fi \
  && tar -xzf fastly.tar.gz --directory /usr/bin && rm -f sha256sums fastly.tar.gz \
  && useradd -ms /bin/bash fastly

RUN npm install -g pnpm

USER fastly
WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

COPY src src
COPY fastly.toml .
COPY tsconfig.json .

CMD [ "pnpm", "run", "dev", "--addr=0.0.0.0:7676", "--verbose" ]
