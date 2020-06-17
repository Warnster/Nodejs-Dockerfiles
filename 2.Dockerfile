#Improved the dockerfile by adding tini package to
#read the sigint and sigterm linux signals to properly shutdown
#the node

#https://github.com/hunterloftis/stoppable
#This package is used to track http connections and send
#them fin packets when node shuts down
FROM node:12-slim

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
#Entrypoint and cmd come together so final command is
#/tini -- node ./bin/www
ENTRYPOINT ["/tini", "--"]

EXPOSE 3000

RUN mkdir /app && chown -R node:node /app

WORKDIR /app

USER node

COPY --chown=node:node package.json package-lock*.json ./

RUN npm intall && npm cache clean --force

COPY --chown=node:node . .

#Switched to node as npm doesn't listen to listen signals
CMD ["node", "./bin/www"]