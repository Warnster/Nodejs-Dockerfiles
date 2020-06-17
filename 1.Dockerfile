#Improved the dockerfile by enabling node user to
#run the process in for extra security

#use node slim as it is roughly 150mb compared with
#900mb from node. Slim is best unless you need to compile
#your own binaries in which case use slim
FROM node:12-slim

EXPOSE 3000

#Own the node packages
RUN mkdir /app && chown -R node:node /app

WORKDIR /app

USER node

COPY --chown=node:node package.json package-lock*.json ./

RUN npm intall && npm cache clean --force

COPY --chown=node:node . .

CMD ["npm", "start"]