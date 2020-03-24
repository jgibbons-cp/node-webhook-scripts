![Logo](https://github.com/aluzed/node-webhook-scripts/raw/master/logo.png "Node Webhook Scripts")

# Node Webhook Scripts (forked)

## Purpose

Execute a script on HTTP call to automate server tasks.

## Installation 

Run : 

```
git clone git@github.com:jgibbons-cp/node-webhook-scripts.git
```

Create a `hooks.js` and a `config.js` file.  Sample files provided.  

## Create a hook or use the sample

In hooks.js : 

```js
module.exports = [
  {
    path: "/kill_stress", 
    command: "sh /home/ec2-user/kill_stress.sh",
    cwd: "/home/ec2-user/",
    method: "post"
  }
]
```
  
By default, if you omit the `method` key, it will send a `GET` request. (uppercase or lowercase...)

You have to declare 4 keys : 
* Path for your HTTP server
* The route method
* The command to run
* The directory where you want to run the script

List of methods : 
* get
* post
* put 
* delete

## Configurations

In `config.js` you only need to export an object : 

```javascript
module.exports = {
  port: 8080, // <- listen port
  token: 'MySecurityT0k3n' // <- to inject in your headers
}
```

## Start server

You can create a service or simply run :

```
node index.js
```

To display webhook trigger you can run with VERBOSE=true in your environment.

```
VERBOSE=true node index.js
```

## Test Script

Let's make some test script `/var/www/scripts/test.sh`

```
#!/bin/bash

echo 'Hellooooooooo WOOOOOOOORLLLLLLD !'
```

With this hook configuration in `hooks.js` : 

```js
module.exports = [
  {
    path: "/hello_world",
    command: "sh /var/www/scripts/test.sh",
    cwd: "/var/www/scripts/",
    method: "post"
  }
]
```

## Callback :

If you prefer use a normal Express callback, you just have to add a "func" key in your hooks.js, with request and result args. (see hooks.sample.js)

![License](https://i.creativecommons.org/l/by-nc-sa/3.0/fr/88x31.png "CC BY NC SA")
  
##Automate creation of a listener
  
1) Launch a host (e.g. AWS)  
2) Add some security group rules
    * ssh and 8080 from your IP to test  
    * 8080 for Datadog webhooks 
      * 34.192.254.186/32  
      * 34.204.102.208/32  
      * 52.20.96.17/32  
3) Create listener:
    * configure variables in create_listener.sh (e.g. HOST)
    * sh create_listener.sh
4) ## Use :

You can test your webhook server with curl or insomnia/postman/whatever...

```
curl -X POST http://IP_OR_HOSTNAME:8080/kill_stress -H 'token: MySecurityT0k3n'

-->

DONE : Hellooooooooo WOOOOOOOORLLLLLLD !
```      