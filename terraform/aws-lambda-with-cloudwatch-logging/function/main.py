import boto3
import os

def handler(event, context):

    try:
        print(f'HelloWorld')
    except Exception as e:
        print(e)

# # Run the function
if __name__ == '__main__':
    handler("", "")
