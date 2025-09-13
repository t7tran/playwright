FROM node:22-bookworm-slim

COPY ./rootfs /

RUN npx -y playwright@1.55.0 install-deps

USER node

RUN mkdir -p /home/node/playwright && \
    cd /home/node/playwright && \
    npm init -y && \
    npm install -D @playwright/test@1.55.0

WORKDIR /home/node/playwright

RUN npx -y playwright install
