resource "aws_dynamodb_table" "dynamo_song_recomendation" { 
   name = "song_recomendation" 
   billing_mode = "PROVISIONED" 
   read_capacity = "30" 
   write_capacity = "30" 
   attribute { 
      name = "noteId" 
      type = "S" 
   } 
   hash_key = "noteId" 
   ttl { 
     enabled = true
     attribute_name = "expiryPeriod"  
   }
   point_in_time_recovery { enabled = true } 
   server_side_encryption { enabled = true } 
   lifecycle { ignore_changes = [ "write_capacity", "read_capacity" ] }
} 

module  "table_autoscaling" { 
   source = "snowplow-devops/dynamodb-autoscaling/aws" 
   table_name = aws_dynamodb_table.dynamo_song_recomendation.name
}