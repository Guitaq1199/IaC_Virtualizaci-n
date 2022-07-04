resource "aws_dynamodb_table" "dynamo_song_recomendation" { 
   name = "SongRecomendation" 
   billing_mode = "PAY_PER_REQUEST" 
   hash_key = "UserId" 
   attribute { 
      name = "UserId" 
      type = "S" 
   }
   
   ttl { 
     enabled = true
     attribute_name = "expiryPeriod"  
   }
   point_in_time_recovery { enabled = true } 
   server_side_encryption { enabled = true } 
} 
