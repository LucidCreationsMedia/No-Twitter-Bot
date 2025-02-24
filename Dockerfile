FROM node:lts-slim AS base

# Create app directory
WORKDIR /usr/src

FROM base AS builder

# Files required by npm install
COPY package*.json ./

# Install app dependencies
RUN yarn install

# Bundle app source
COPY . .

# Type check app
RUN yarn typecheck

FROM base AS runner

# Files required by npm install
COPY package*.json ./

# Install only production app dependencies
RUN yarn install --production

# Bundle app source
COPY . .

USER node

# Start the app
EXPOSE 80
CMD ["node", "--import", "tsx", "./src/main.ts"]