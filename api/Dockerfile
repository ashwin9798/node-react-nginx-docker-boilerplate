# pull the Node.js Docker image
FROM node:alpine

# create the directory inside the container
WORKDIR /usr/src/app

# copy the package.json files from local machine to the workdir in container
COPY package*.json ./

# run npm install in our local machine
RUN npm install --silent

# copy the generated modules and all other files to the container
COPY . .

# our app is running on port 5000 within the container, so need to expose it
EXPOSE 5000

# the command that starts our app
CMD ["node", "index.js"]
