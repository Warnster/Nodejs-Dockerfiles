#Switched into multistage builds, first being production
FROM node:12-slim as base
ENV NODE_ENV=production
ENV TINI_VERSION v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
EXPOSE 3000

RUN mkdir /app && chown -R node:node /app
WORKDIR /app
USER node
COPY --chown=node:node package.json package-lock*.json ./

#npm ci install versions from package-lock
RUN npm ci && npm cache clean --force
COPY --chown=node:node . .
CMD ["node", "./bin/www"]

#Development build
FROM base as dev

ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
RUN npm install --only=development
#nodemon used for entrypoint
CMD ["nodemon", "./bin/www", "--inspect=0.0.0.0:9229"]

#only pulls in only source code
FROM base as source
COPY --chown=node:node . .

#Builds a test env pulls in dev dependancies
FROM source as test

ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
COPY --from=dev /app/node_modules /app/node_modules
RUN eslint .
RUN npm test
CMD ["npm", "run", "test"]

FROM source as prod
ENTRYPOINT ["/tini", "--"]
CMD ["node", "./bin/www"]