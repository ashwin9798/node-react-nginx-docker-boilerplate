# Node.js | React | Docker | Nginx -- Boilerplate

A ready to go Dockerized boilerplate for any web project, with Node.js backend, React frontend and Nginx proxy.

## Easily deploy this app to Elastic Beanstalk with CI/CD

With a little configuration on the AWS console, this multi-container app can be deployed on Elastic Beanstalk with CodeBuild/CodePipeline CI/CD.

Follow this article I wrote to set up the AWS services for this app: 
https://ashwin9798.medium.com/deploy-multi-container-docker-app-with-ci-cd-to-elastic-beanstalk-w-aws-ecr-codebuild-and-ed5d03770b7b

## Build and Test

Make sure nothing is running on port 80 of your local machine

Run `docker-compose up --build` from the root of the project to spin up the containers

## Deploy

Push to master, and CI/CD takes care of the rest!

## Routes 
Backend: http://localhost:80/api/

Frontend: http://localhost:80/
