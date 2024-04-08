data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
    name = var.execution_role
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "basic_execution_role" {
    name = "LabmdaBasicExecutionRole"
    role = aws_iam_role.lambda_execution_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-2:490489140525:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-2:490489140525:log-group:/aws/lambda/${var.execution_role}:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "microservice_exec_role" {
    name = "AWSLambdaMicroserviceExecutionRole"
    role = aws_iam_role.lambda_execution_role.id
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Resource": "${var.db_arn}/*"
        }
    ]
}
EOF
}


#Build_simple_API_lambda_code
resource "aws_lambda_function" "lambda_func" {
    filename = "modules/module2/lambda/Build_simple_API_lambda_code.zip"
    function_name = var.execution_role
    role = aws_iam_role.lambda_execution_role.arn
    handler = "Build_simple_API_lambda_code.lambda_handler"
    runtime = "python3.9"
    environment {
        variables = {
            foo = "bar"
        }
    }
}

resource "aws_lambda_permission" "allow_triger" {
  statement_id  = "AllowAPIgatewayInvokation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_arn
}