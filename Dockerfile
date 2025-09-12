FROM node:22-bookworm-slim

RUN npx -y playwright install-deps

USER node

RUN mkdir -p /home/node/playwright && \
    cd /home/node/playwright && \
    npm init -y && \
    npm install -D @playwright/test

WORKDIR /home/node/playwright

RUN npx -y playwright install
