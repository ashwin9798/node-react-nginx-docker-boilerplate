FROM node:alpine
ENV CI=true
WORKDIR /app
COPY package.json ./
RUN npm install --silent
COPY . .
CMD ["npm", "start"]
