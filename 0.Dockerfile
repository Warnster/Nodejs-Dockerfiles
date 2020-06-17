#This is a basic node dockerfile which should
#never be used.

FROM node:12

EXPOSE 3000

WORKDIR /app

COPY package.json package-lock*.json ./

RUN npm intall && npm cache clean --force

COPY . .

CMD ["npm", "start"]