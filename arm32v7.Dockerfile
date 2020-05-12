# ---------------
# Install Dependencies
# ---------------
FROM node:12-alpine as build

# Install dependencies neccesary for node-gyp on node alpine
RUN apk add --update --no-cache \
    python \
    make \
    g++

# Install app dependencies
COPY package.json .
RUN npm install --production --silent

# Install dependencies necessary for build and start
RUN npm install -D cross-env typescript @types/react @next/bundle-analyzer

# ---------------
# Build App
# ---------------
FROM arm32v7/node:12-alpine

WORKDIR /app

# Copy dependencies from build stage
COPY --from=build node_modules node_modules

# Rebuild dependency for current arch
RUN npm rebuild ln-service

# Bundle app source
COPY . .
RUN npm run build
EXPOSE 3000

CMD [ "npm", "start" ]