import boto3
import json

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('${var.tag}-db')

    response = table.scan()
    items = response['Items']

    return {
        'statusCode': 200,
        'body': json.dumps(items)
    }
