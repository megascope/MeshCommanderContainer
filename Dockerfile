FROM node:20

WORKDIR /home/node
USER node

ARG MESHCOMMANDER_VERSION=latest

RUN npm install --omit=dev "meshcommander@${MESHCOMMANDER_VERSION}" \
    && npm cache clean --force

EXPOSE 3000
CMD ["node", "node_modules/meshcommander", "--any"]
