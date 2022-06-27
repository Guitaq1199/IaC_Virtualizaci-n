import json
import boto3

def lambda_handler(event, context):
    rekognitionClient = boto3.client('rekognition')
    s3Client = boto3.client('s3')
    fileImage = s3Client.get_object(Bucket='proyectovirtualizacion2022v1', Key='profilepic.jpg')
    fileRead = fileImage['Body'].read()
    response = rekognitionClient.detect_faces(Image={'S3Object': {'Bucket': 'proyectovirtualizacion2022v1', 'Name': 'profilepic.jpg'}}, Attributes=["ALL"])
    faceResponse = response['FaceDetails']
    emotionsData = faceResponse[0]['Emotions'][0]

    return {
        'statusCode': 200,
        'body': emotionsData
    }

    