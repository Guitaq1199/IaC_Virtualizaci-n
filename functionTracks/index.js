const https = require("https");
exports.handler = async (event) => {
    // TODO implement
    
    let respuesta = "";
    let file_name = event['name'];
    let path = ""; 
    path = "/v1/playlists/"+file_name+"/tracks";
  
  var options = {
    hostname: "api.spotify.com",
    port: 443,
    path: path,
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
            let body = JSON.parse(respuesta);
            //console.log(body.body);
            let id = [];
            for(let i=0; i<10;i++){
              id.push(body.items[i].track.id) 
            }
            resolve({
                id: id
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
    
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    
    return promise;
};