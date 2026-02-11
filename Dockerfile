FROM node:24-bookworm-slim

COPY ./rootfs /

# install utilities
RUN \
    echo "deb http://deb.debian.org/debian bookworm contrib non-free" > /etc/apt/sources.list.d/contrib.list && \
    apt update && \
    apt install -y --no-install-recommends curl zip unzip ca-certificates gnupg && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt update && \
    apt install -y --no-install-recommends google-cloud-sdk-gke-gcloud-auth-plugin && \
    curl -fsSLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.52.2/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    curl -fsSLo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.8.1/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -fsSLo /usr/local/bin/kubectl https://dl.k8s.io/release/`curl -sL https://dl.k8s.io/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apt install -y --no-install-recommends \
        fonts-dejavu-core \
        fonts-dejavu-extra \
        fonts-freefont-ttf \
        ttf-mscorefonts-installer \
        fonts-noto-cjk \
        fonts-noto-cjk-extra \
        fonts-wqy-zenhei \
        fonts-wqy-microhei && \
    npx -y playwright@1.58.2 install-deps && \
    npx -y playwright@1.58.2 install chrome && \
    # cleanup
    apt clean && apt autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/*

USER node

RUN mkdir -p /home/node/playwright && \
    cd /home/node/playwright && \
    npm init -y && \
    npm install -D \
        @playwright/test@1.58.2 \
        js-yaml

WORKDIR /home/node/playwright

RUN npx -y playwright install
