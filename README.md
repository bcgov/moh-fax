# Special Authority Web Service

## Requirements

* Node 
* Git
* npm
### Node
- #### Node installation on Windows

  Just go on [official Node.js website](https://nodejs.org/) and download the installer.
Also, be sure to have `git` available in your PATH, `npm` might need it (You can find git [here](https://git-scm.com/)).
- #### Node installation on Ubuntu

  You can install nodejs and npm easily with apt install, just run the following commands.

      $ sudo apt install nodejs
      $ sudo apt install npm
If the installation was successful, you should be able to run the following command.

    $ node --version
    v14.17.1
    $ npm --version
    6.14.3


## Setup for First time Users
Clone the repo and install the dependencies.

```bash
git clone https://github.com/bcgov/moh-fax.git
cd moh-fax
```

```bash
npm install
```

## Configuration
* Change PORT in config file as per preferred port number.
* Change Path in config to the location where pdf and control files are supposed to be saved.

## Running the Project Locally
```
# To start..
npm start
```
## API

### Request in Windows 

`POST /SA/sf2fsc`

    Use postman for POST request with URL:
    http:// localhost:7000/SA/sf2fsc 
    replace 7000 with PORT in config file.
    Add below parameters in the body of the request.
    {
        "caseNumber":"00001098",
        "recipientName":"John",
        "faxNumber":"6044345984",
        "attachment":"base64 of the pdf",
        "emails":["test9@outlook.com"],
        "caseId":"5001f000002yAR0AAM"
    }

### Response
    200 OK
    A pdf and a .control file being created in the location(PATH) in config file.


### Request in Linux

`POST /SA/sf2fsc`

    curl -d {"key1":"value1","key2":"value2","key3":"value3"} http://localhost:7000/SA/sf2fsc

### Response
    200 OK

## Running the Project on BC Servers
```
ssh <idir>@fireblade.hlth.gov.bc.ca # enter your IDIR

sudo -u gfadmin /bin/bash -login # enter your IDIR

# app is located here:
/data/gfadmin/software/nodejs/apps/moh-fax/moh-fax-main

# To start..
npm start
```
This starts the server in background in listening mode on port configured in config file.

## Running Service in the Background
```
#Login using IDIR Credentials(Needs Approval and access to Fireblade)
ssh <idir>@fireblade.hlth.gov.bc.ca # enter your IDIR

# Start the service
sudo systemctl start filescan_nodejs

# Stop the service
sudo systemctl stop filescan_nodejs

# Check status
systemctl status filescan_nodejs 
```


