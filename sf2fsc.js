const fs = require('fs');
const path=require('path');
const config=require('config')
const dir=config.get("loc.path");

function exec(items) {
    var result=[];
    var successResultObject={"status":"success","status_code":"200"};
    var failResultObject={"status":"fail","error":"Invalid Parameter"};

    if(items.length==0){   

        result.push(failResultObject);
        return result;
    }
    for(i=0;i<items.length;i++){
        
        let cases=items[i].caseNumber;
        let name=items[i].recepeintName;
        let fax=items[i].faxNumber;
        let attachment=items[i].attachment;

        if(cases===null||name===null||fax===null||attachment===null||cases.length===0||name.length===0||fax.length===0||attachment.length===0){                  
            result.push(failResultObject);
        }
    
        else {
            execs(items[i].caseNumber,items[i].recepeintName,items[i].faxNumber,items[i].attachment);      
            result.push(successResultObject);
        }
    }
    return result;
}

function execs(caseNumber,recepeintName,faxNumber,attachment)
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