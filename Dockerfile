FROM node:latest
LABEL description="A demo Dockerfile for build Docsify."
WORKDIR /docs
RUN npm set registry https://registry.npm.taobao.org/
RUN npm install -g live-server@latest docsify-cli@latest
RUN npm run server
CMD npm run start