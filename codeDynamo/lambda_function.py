import boto3
import json


def lambda_handler(event, context):
    method=event["Method"]
    if method == "Insert":
        response = insert(event)
    elif method == "Update":
        response = Update(event)
    elif method == "Delete":
        response = Delete(event)
    elif method == "GetUser":
        response = GetUser(event)
    elif method == "Get":
        response = Get(event)
    return response

def insert(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    name=event["SongList"]
    response=table.put_item(Item={"UserId":id1,"SongList":name})
    return response

def Update(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    id1=event["UserId"]
    newSong = event["SongList"]
    response = table.get_item(Key={'UserId':id1})
    if "Item" in response:
        SongList = response["Item"]["SongList"]
        for song in newSong:
            if not song in SongList:
                SongList.append(song)
        response=table.put_item(Item={"UserId":id1,"SongList":SongList})
        return response
    else:
        response=table.put_item(Item={"UserId":id1,"SongList":newSong})
        return response

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
        return response
    else:
        return

def Get(event):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('SongRecomendation')
    response = table.scan()
    response = response["Items"]
    return response