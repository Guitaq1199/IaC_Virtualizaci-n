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
    client_cred = "fa55ab64b85149fdba7e7568f24636e9:b7f86240d1cb4061ac154e55cb8ef92d"
    client_cred_b64 = base64.b64encode(client_cred.encode())
        
    token_data = {
        "grant_type": "client_credentials"
    }
    token_header = {
        "Authorization": f"Basic {client_cred_b64.decode()}"
    }
    
    r = requests.post('https://accounts.spotify.com/api/token', data = token_data, headers = token_header)
    token_data = r.json()
    access_token = token_data['access_token']
    
    try:
        s3_response = s3Client.put_object(Bucket= BUCKET_NAME, Key= file_name, Body= file_content) 
    except Exception as e:
        raise IOError(e)
    
    fileImage = s3Client.get_object(Bucket= BUCKET_NAME, Key= file_name)
    fileRead = fileImage['Body'].read()
    response = rekognitionClient.detect_faces(Image={'S3Object': {'Bucket': BUCKET_NAME, 'Name': file_name}}, Attributes=["ALL"])
    faceResponse = response['FaceDetails']
    emotionsData = faceResponse[0]['Emotions'][0]
    emotionDataType = emotionsData["Type"]
    
    if emotionsData["Type"] == "HAPPY" or emotionsData["Type"] == "SURPRISED":
        emotionsData["Type"] = "HAPPY"
    elif emotionsData["Type"] == "CALM":
        emotionsData["Type"] = "CALM_VIBES"
    else:
        emotionsData["Type"] = "HAPPY"
        
    dataEmotion = emotionsData["Type"]
        
    response = requests.get(f"https://dnnytrqkn7.execute-api.us-east-1.amazonaws.com/v1/playlist?name={dataEmotion}&token={access_token}")
    
    return {
        'statusCode': 200,
        'body': response.json(),
        'Emotions': emotionDataType
    }