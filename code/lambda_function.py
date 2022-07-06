import json
import boto3
import base64
import requests

BUCKET_NAME = 'proyectovirtualizacion2022v1'

def lambda_handler(event, context):
    
    file_content = base64.b64decode(event['content'])
    file_name = event['name']
    rekognitionClient = boto3.client('rekognition')
    s3Client = boto3.client('s3')
    
    try:
        s3_response = s3Client.put_object(Bucket= BUCKET_NAME, Key= file_name, Body= file_content) 
    except Exception as e:
        raise IOError(e)
    
    fileImage = s3Client.get_object(Bucket= BUCKET_NAME, Key= file_name)
    fileRead = fileImage['Body'].read()
    response = rekognitionClient.detect_faces(Image={'S3Object': {'Bucket': BUCKET_NAME, 'Name': file_name}}, Attributes=["ALL"])
    faceResponse = response['FaceDetails']
    emotionsData = faceResponse[0]['Emotions'][0]
    
    if emotionsData["Type"] == "HAPPY" or emotionsData["Type"] == "SURPRISED":
        emotionsData["Type"] = "HAPPY"
    elif emotionsData["Type"] == "CALM":
        emotionsData["Type"] = "CALM VIBES"
    else:
        emotionsData["Type"] = "HAPPY"
        
    dataEmotion = emotionsData["Type"]
        
    response = requests.get(f"https://lavl8xge0b.execute-api.us-east-1.amazonaws.com/v1/playlist?name={dataEmotion}")
    
    return {
        'statusCode': 200,
        'body': response.json()
    }