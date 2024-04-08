import boto3
import json

def lambda_handler(event, context):
    # Create a DynamoDB client
    try:
        dynamodb = boto3.client('dynamodb')
        table_name = 'http-get-items'
        primary_key_value = event['rawPath'].split("/")[-1]
        response = dynamodb.get_item(TableName=table_name,Key={'id': {'S': primary_key_value}})
        item = response['Item']
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }
    except:
        return {
            'statusCode': 404,
            'body': 'Unable to retrieve the DynamoDB entry'
        }