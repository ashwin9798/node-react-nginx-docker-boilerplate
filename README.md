# Node.js | React | Docker | Nginx -- Boilerplate

A ready to go Dockerized boilerplate for any web project, with Node.js backend, React frontend and Nginx proxy. 

## Build and Test Locally

Make sure nothing is running on port 80 of your local machine

Run `docker-compose up --build` from the root of the project to spin up the containers

## Localhost Routes 
Backend: http://localhost:80/api/

Frontend: http://localhost:80/

## Setting up automated AWS Deployment (Elastic Beanstalk + CI/CD)

This project has pre-configured Terraform code that will create all our AWS infrastructure for us, and also create the CI/CD pipeline. There are a few manual steps to get everything working properly.

### Step 1: Download this repo as a zip, create your own git repository, and push to Github

Download the zip of this repo on your local machine. 

Then create an empty git repository inside with the `git init` command in the root directory. 

Also create a repository on Github that you will push to. Commit all the files and push to Github.

### Step 2: Run the initialization script
Run `./init.sh` in your terminal in the root directory, it will ask you for the following information:

**AWS Account ID:** The AWS Account ID is found by logging into your AWS console and clicking the dropdown next to your name. The number next to 'My Account' is the account ID.

**AWS Region:** Where you want your application to be hosted. A list of regions can be found here: https://howto.lintel.in/list-of-aws-regions-and-availability-zones/. Type in the code corresponding to the region you want to deploy to (us-west-1, us-east-1, etc.)

**Name of application:** What you'd like to name your application. All the AWS services that we will provision will have this in the prefix, so make it informative and related to the product.

### Step 3: Fill in terraform.tfvars

After you answer these questions, you will see a new file created in the terraform folder called `terraform.tfvars`, with a few fields already populated. You'll need to fill in the rest.

**aws_access_key** and **aws_secret_key**: follow the steps here: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys to get access keys that will allow Terraform to access your AWS account and create everything.

**github_repo_name**: name of the Github repo that you created for your project

**github_username**: your GitHub username

**github_oauth_token**: Visit your GitHub settings page then go to -> Developer Settings -> Personal Access Tokens. Create a new access token and call it whatever you want. Just make sure it has access to the repo (check the repo checkbox). Copy the generated OAuth token into the tfvars file.

**NOTE:** If you want to change the aws_region, application_name, or aws_account_id, rerun the init script so that the variables are consistent everywhere.

### Step 4: Install Terraform

If you don't have Terraform installed already, follow the steps here: https://learn.hashicorp.com/tutorials/terraform/install-cli

Or use Homebrew: `brew install terraform`

### Step 5: Run Terraform to create the AWS infrastructure

`cd terraform` 

and then run the following commoand:

`terraform init`

After you run `terraform init`, there will likely be errors due to issues with 3rd party code. To fix these, make the following replacement:

`required_version  "~> 0.12.0"` --> `required_version = ">= 0.12.0, < 0.14.0"`

Make the above change in the following files:
- terraform/.terraform/modules/build.codebuild/versions.tf
- terraform/.terraform/modules/build.codebuild.label/versions.tf
- terraform/.terraform/modules/build.label/versions.tf

Rerun `terraform init`

Finally, run:

`terraform apply`

type "yes" when prompted to create the AWS infrastructure.

## Deploy

Push to the master branch of your repo and CI/CD takes care of the rest!
