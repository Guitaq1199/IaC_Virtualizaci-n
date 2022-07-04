const https = require("https");
exports.handler = async (event) => {
    // TODO implement
    
    let respuesta = "";
    let body;
    let respuesta1 = "";
    let body1;  
  
  var options = {
    hostname: "api.spotify.com",
    port: 443,
    path: "/v1/search?q=happy&type=playlist&include_external=audio",
    method: 'get',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': "Bearer BQBg4q4kTX879h_eJ1Dcv39vQUSY1mgB0klL-TQR2M8vaLP9o_ngQXytq3Vnkq0j6SY7qqGVParpemp8omfRqSoX1ndeAgmhwjYGcvKUxL8kSHRUwTFhH0DAM_y9r49Oyh-UZ652b6pVbknd8ykQrjHkwwAUcehJToqyQt9C0DJd7TzZQLeuToY"
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
                body: body.playlists.items[0].id
            });
        });
    });
    rec.on("error", (e) => {
       reject({
           statusCode: 500,
           body: "Peto"
       }) 
    });
    
    });
    
    const promise1 = await new Promise((resolve,reject) => {
    
    const rec = https.get(`https://km3ipz40zl.execute-api.us-east-1.amazonaws.com/v1/playlist/track?name=${body.playlists.items[0].id}`, function(res){
        res.on("data", chunk => {
            respuesta1 += chunk;
        });
        res.on("end", () => {
            body1 = JSON.parse(respuesta1);
            resolve({
                body1: body1
            });
        });
    });
    rec.on("error", (e) => {
       reject({
           statusCode: 500,
           body: "Error al consultar la API"
       }) 
    });
    
    });
    
    return promise1;
};