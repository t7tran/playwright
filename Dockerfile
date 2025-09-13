FROM node:22-bookworm-slim

COPY ./rootfs /

RUN npx -y playwright@1.55.0 install-deps && \
    # install utilities
    apt update && \
    apt install -y --no-install-recommends curl zip unzip && \
    # cleanup
    apt clean && apt autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/*

USER node

RUN mkdir -p /home/node/playwright && \
    cd /home/node/playwright && \
    npm init -y && \
    npm install -D \
        @playwright/test@1.55.0 \
        js-yaml

WORKDIR /home/node/playwright

RUN npx -y playwright install
