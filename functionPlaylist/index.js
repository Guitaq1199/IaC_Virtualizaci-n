const https = require("https");
exports.handler = async (event) => {
    // TODO implement
    
    let respuesta = "";
    let respuesta1 = "";  
    let file_name = event['name'];
    let token_name = event['token'];
    let body = "";
    let hostname = "api.spotify.com";
    let ContentType = "application/json"
    let Authorization = "Bearer " + token_name;
    let file_number = Math.floor(Math.random()*10) + 0;

  var options = {
    hostname: hostname,
    port: 443,
    path: "/v1/search?q=" + file_name + "&type=playlist&include_external=audio",
    method: 'get',
    headers: {
      'Content-Type': ContentType,
      'Authorization': Authorization
    }
  };
    
    const promise = await new Promise((resolve,reject) => {
    
    const rec = https.get(options, function(res){
        res.on("data", chunk => {
            respuesta += chunk;
        });
        res.on("end", () => {
            body = JSON.parse(respuesta);
            resolve({
                body: body.playlists.items[file_number].id
            });
        });
    });
    rec.on("error", (e) => {
       reject({
           statusCode: 500,
           body: "Internal server error"
       }) 
    });
    
    });
    
    
   var options1 = {
    hostname: hostname,
    port: 443,
    path: "/v1/playlists/"+body.playlists.items[file_number].id+"/tracks",
    method: 'get',
    headers: {
      'Content-Type': ContentType,
      'Authorization': Authorization
    }
  };
  
  const promise1 = await new Promise((resolve,reject) => {
    
    const rec = https.get(options1, function(res){
        res.on("data", chunk1 => {
            respuesta1 += chunk1;
        });
        res.on("end", () => {
            let body1 = JSON.parse(respuesta1);
            let id = [];
            for(let i=0; i<10;i++){
              id.push(body1.items[i].track.id) 
            }
            resolve({
                id: id
            });
        });
    });
    rec.on("error", (e) => {
       reject({
           statusCode: 500,
           body: "Internal server error API"
       }) 
    });
    
    });
    
    return promise1;
    
};