# ServerLess_Ordering_Application
API in AWS with Terraform

This repository defines the infrastructure for a simple API service on AWS using Terraform. The API utilizes the following AWS services:

    API Gateway: Creates a publicly accessible API endpoint for your service.
    DynamoDB: Provides a NoSQL database to store and retrieve data.
    Lambda: Serverless compute service that runs your API logic.

Getting Started

Prerequisites:

    Terraform installed (terraform -v to verify)
    AWS CLI configured with access keys and permissions to create the required resources.

Steps

    Clone this repository.

    Edit the terraform.tfvars file and configure the required variables:
        api_name: Name of your API (default: http-get-api)
        execution_role: IAM Role name (default: http-get-role)
        db_name: Name of your DynamoDB table (default: http-get-items)
        (Optional) instance_names: List of names for your EC2 instances (default: ["Endpoint-A", "Endpoint-B"])

    Run terraform init to initialize Terraform and download required providers.

    Run terraform plan to preview the changes Terraform will make.

    Run terraform apply to create the infrastructure on AWS.

Outputs

    api_url: URL of your deployed API
    db_arn: DynamoDB table ARN
    lambda_invoke_arn: Lambda function invocation ARN

Note: This configuration includes commented-out sections for EC2 instances and a separate modules structure. These can be uncommented and customized for a more complex deployment involving EC2 instances.
Code Breakdown

The Terraform code is organized using modules for better maintainability. Here's a breakdown of the main resources:

    API Gateway:
        Defines an API resource with a path named "items" that accepts GET requests.
        Integrates with a Lambda function to handle the request.
        Deploys the API and provides the public invocation URL as an output.
    DynamoDB:
        Creates a DynamoDB table with a single hash key ("id").
        Populates the table with sample data (can be removed for production).
        Provides the table ARN as an output for access control.
    Lambda:
        Defines a Lambda function using the provided code (located in modules/module2/lambda/Build_simple_API_lambda_code.zip).
        Grants API Gateway permission to invoke the Lambda function.
        Provides the Lambda function invocation ARN as an output.
    IAM Roles:
        Creates an IAM role for the Lambda function with access to CloudWatch Logs and DynamoDB operations.

Security Considerations

    This is a basic example and might not be suitable for production environments.
    Consider implementing additional security measures like access control lists (ACLs) and IAM policies.
    Do not store sensitive information in the Terraform configuration. Use AWS Secrets Manager for sensitive data.

Further Customization

This code provides a starting point for building your API service on AWS. You can customize it by:

    Modifying the Lambda function code to implement your desired functionality.
    Adding additional resources as needed (e.g., security groups, VPC).
    Using environment variables to configure your Lambda function.

I hope this comprehensive README helps you understand and deploy the infrastructure for your API service using Terraform!


Envirenment var: '$env:Path += ";C:\Program Files\Terraform"'
c:/Program\ Files/Terraform/terraform.exe
