#!/bin/bash

rm .env 2> /dev/null

# Ask the user for their AWS account id
read -p 'Type in your AWS account ID: ' aws_account_id

read -p 'Type in the AWS region you would like (e.g.: us-west-2, us-east-1): ' aws_region

read -p 'Name your application/product: ' application_name


echo -e "AWS_ACCOUNT_ID=${aws_account_id}" >> .env
echo -e "AWS_REGION=${aws_region}"  >> .env
echo -e "APPLICATION_NAME=${application_name}" >> .env

sed -e "s/\${AWS_ACCOUNT_ID}/$aws_account_id/g" \
    -e "s/\${AWS_REGION}/$aws_region/g" \
    -e "s/\${APPLICATION_NAME}/$application_name/g"\
    Dockerrun.aws.json.template > Dockerrun.aws.json

cat ./terraform/terraform.example.tfvars > ./terraform/terraform.tfvars

sed -i '' "s/application_name = \"\"/application_name = \"$application_name\"/g" ./terraform/terraform.tfvars |
sed -i '' "s/aws_region = \"\"/aws_region = \"$aws_region\"/g" ./terraform/terraform.tfvars |
sed -i '' "s/aws_account_id = \"\"/aws_account_id = \"$aws_account_id\"/g" ./terraform/terraform.tfvars
