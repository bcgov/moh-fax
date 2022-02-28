const fs = require('fs');
const path=require('path');
const config=require('config')
const dir=config.get("loc.path");

function exec(caseNumber,recepeintName,faxNumber,attachment)
{
    if(attachment==null)
    {
        attachment =caseNumber+'.pdf';
    }
    let text=`#SENDER_EMAIL sa@hlth.gov.bc.ca \n`;
    text+=`#RECIP_NAME ${recepeintName}\n`;
    text+=`#DESTINATION FAX ${faxNumber}\n`;
    text+=`#ATTACHMENT ${caseNumber}.pdf`;

    fs.writeFileSync(path.join(`${dir}`,caseNumber+'.pdf'),attachment,'base64',function(err){console.log(err);});
    fs.writeFileSync(path.join(`${dir}`,caseNumber+'.control'),text,'',function(err){console.log(err);});

}
 
 module.exports={exec};
