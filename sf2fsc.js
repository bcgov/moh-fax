const fs = require('fs');
const path=require('path');
const config=require('config')
const dir=config.get("loc.path");

function exec(items) {
   
    var result=[];
    var successResultObject={"status":"success"};
    var failResultObject={"status":"fail","error":"Invalid Parameter"};

    if(!items || items.length==0){   
        result.push(failResultObject);
        return result;
    }

    for(let i=0; i<items.length; i++){    
        let item = items[i];
        let caseNumber = item.caseNumber;
        let name = item.recepientName;
        let fax = item.faxNumber;
        let attachment = item.attachment;
        let emails = item.emails;

        if( !caseNumber || !name || !fax || !attachment || !emails || emails.length == 0) {
            result.push(failResultObject);
        }
        else {
            execs(item.caseNumber,item.recepeintName,item.faxNumber,item.attachment, item.emails.join(','));      
            result.push(successResultObject);
        }
    }
    return result;
}

function execs(caseNumber,recepeintName,faxNumber,attachment,emails) {
    
    let text=`#SENDER_EMAIL sa@hlth.gov.bc.ca\n`;
    text+=`#RECIP_NAME ${recepeintName}\n`;
    text+=`#DESTINATION FAX ${faxNumber}\n`;
    text+=`#ATTACHMENT ${caseNumber}.pdf \n`;
    text+= `#NOTIFY ALL EMAIL ${emails}`;
    
    
    fs.writeFileSync(path.join(`${dir}`,caseNumber+'.pdf'),attachment,'base64',function(err){console.log(err);});
    fs.writeFileSync(path.join(`${dir}`,caseNumber+'.control'),text,'',function(err){console.log(err);});

}
 module.exports={exec};