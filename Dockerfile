FROM n8nio/n8n:latest

USER root

# Install Chrome dependencies (Debian/Ubuntu based)
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    fonts-freefont-ttf \
    ca-certificates \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Tell Puppeteer to use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

# Install puppeteer dependencies
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install --save \
    puppeteer-core \
    puppeteer-extra \
    puppeteer-extra-plugin-stealth \
    puppeteer-extra-plugin-user-data-dir \
    puppeteer-extra-plugin-user-preferences

# Install n8n-nodes-puppeteer in correct location
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm init -y && \
    npm install n8n-nodes-puppeteer --legacy-peer-deps

# Fix permissions
RUN chown -R node:node /home/node/.n8n

USER node
