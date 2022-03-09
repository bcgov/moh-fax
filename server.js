const http = require('http');
const sf2fsc=require("./sf2fsc")
const config=require('config')

const PORT=config.get('webServer.port');
const options = {
  protocol: 'http:',
  port: `${PORT}`,
  path: 'SA/sf2fsc',
  method: 'POST',
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8'
  }
};
const server = http.createServer(options,(req, res) => {
  if (req.method === 'POST' && req.url.toLocaleLowerCase() ==='/SA/sf2fsc'.toLocaleLowerCase()) {
    let body = '';

    req.on('data', chunk => {
        body += chunk.toString(); // convert Buffer to string
    });

    req.on('end', () => {
      var parsedBody = JSON.parse(body);
      let results;

      try {
        results = sf2fsc.exec(parsedBody);      
        body = JSON.stringify(results);
      } catch(error) {
        res.statusCode = 500;
        body = `Server error: ${error}`; 
      }
      
      // Check for validation errors.
      if(results && results.length>0) { 
      for (let i = 0; i < results.length; i++) {
        if ('success' != results[i].status.toLowerCase()) {
          res.statusCode = 400;
        }
      }
    }
      
      res.end(body);
    });
  }
  else {
    res.statusCode = 404;
    res.end();
  }
});
server.listen(`${PORT}`);