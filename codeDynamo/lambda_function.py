import boto3
import json


def lambda_handler(event, context):
    print(event)
    body = json.loads(event["body"])
    method=body["Method"]
    if method == "Insert":
        response = insert(body)
    elif method == "Update":
        response = Update(body)
    elif method == "Delete":
        response = Delete(body)
    elif method == "GetUser":
        response = GetUser(body)
    elif method == "Get":
        response = Get(body)
    return response

def insert(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    name=event["SongList"]
    response=table.put_item(Item={"UserId":id1,"SongList":name})
    return {
        'statusCode': 200,
    }

def Update(event):
    print(event)
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    newSong = event["SongList"]
    response = table.get_item(Key={'UserId':id1})
    print(response)
    print(id1)
    print(newSong)
    if "Item" in response:
        SongList = response["Item"]["SongList"]
        for song in newSong:
            if not song in SongList:
                SongList.append(song)
        response=table.put_item(Item={"UserId":id1,"SongList":SongList})
    else:
        response=table.put_item(Item={"UserId":id1,"SongList":newSong})
        print(response)
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type,Access-Control-Allow-Origin',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
        
    }

def Delete(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    response = table.delete_item(Key={'UserId':id1})
    return response

def GetUser(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    response = table.get_item(Key={'UserId':id1})
    if "Item" in response:
        return {
        'statusCode': 200,
        'body': json.dumps(response["Item"]),
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type,Access-Control-Allow-Origin',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
        }
    else:
        return {
        'statusCode': 404,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type,Access-Control-Allow-Origin',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
        }

def Get(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    response = table.scan()
    response = response["Items"]
    return {
    'statusCode': 200,
    'body': json.dumps(response),
   'headers': {
        'Access-Control-Allow-Headers': 'Content-Type',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
    }