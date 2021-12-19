FROM node:latest
LABEL description="学习笔记"
WORKDIR /notes-server
COPY . /notes-server
RUN npm set registry https://registry.npm.taobao.org/
RUN npm install -g live-server@latest docsify-cli@latest pm2@latest
CMD npm run start:prd