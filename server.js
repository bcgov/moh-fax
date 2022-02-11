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
  if (req.method === 'POST'&& req.url==='/SA/sf2fsc') {
    let body = '';
    req.on('data', chunk => {
        body += chunk.toString(); // convert Buffer to string
    });

    req.on('end', () => {
      var parsedBody =JSON.parse(body);
  
    sf2fsc.exec(parsedBody.caseNumber,parsedBody.recipientName,parsedBody.faxNumber,parsedBody.attachment);
      res.end('ok');
    });
  }
    else {
      res.end();
    }
});
server.listen(`${PORT}`);