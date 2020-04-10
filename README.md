![Logo](https://github.com/aluzed/node-webhook-scripts/raw/master/logo.png "Node Webhook Scripts")

##Automate creation of a listener and auto-remediation of a CPU hogged process using Datadog 
  
NOTE: demo is listener_demo.mov  

1) Launch a host (e.g. AWS)  This can be used if you can't use the AWS EventBridge for example.
2) Add some security group rules
    * ssh and 8080 from your IP to test  
    * 8080 for Datadog webhooks 
      * 34.192.254.186/32  
      * 34.204.102.208/32  
      * 52.20.96.17/32  
3) Create a listener, stress the CPU, create three Datadog monitors and a webhook to remediate killing the process.
What you will see is the CPU spike, the webhook will fire when all three monitors alert and the CPU will recover.
    * configure variables in .env_vars 
    * load environment variables: source .env_vars.sh  
    * kick-off process: sh install.sh  

You can test your webhook server with curl, insomnia/postman/Datadog alert...

```
curl -X POST http://IP_OR_HOSTNAME:8080/kill_stress -H 'token: MySecurityT0k3n'

-->
```      

4) Clean up (other than the webhook which can't be removed via the API, but the next call will fail if it is there or update it)- python remove_monitors.py

Notes: this has been tested with OSX to launch and Amazon Linux as the host.  It could use some more defensive programming, 
and will do if need or time warrants.  If you run into issues please submit an issue or PR. 
