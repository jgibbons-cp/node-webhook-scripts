#!/bin/bash

#install stress
ssh $USER@$HOST "sudo amazon-linux-extras install epel -y ; sudo yum install stress -y"

#install Datadog agent
scp $ENV_VARS $USER@$HOST:/tmp
ssh $USER@$HOST "source /tmp/$ENV_VARS ; curl -O https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh ; sh install_script.sh ; rm /tmp/$ENV_VARS"

#configure process collection and restart the agent
scp datadog.yaml $USER@$HOST:/tmp
ssh $USER@$HOST "sed -i 's/datadog_api_key/$DD_API_KEY/g' /tmp/datadog.yaml"
ssh $USER@$HOST "sudo mv /tmp/datadog.yaml /etc/datadog-agent/datadog.yaml ; sudo service datadog-agent restart"

#run stress
ssh -f $USER@$HOST "nohup stress --cpu 3 &>/dev/null"

#get instance ID
ssh $USER@$HOST curl -O http://169.254.169.254/latest/meta-data/instance-id
scp $USER@$HOST:/home/$USER/$INSTANCE_ID_STORE .

#create webhook
curl -v -X PUT \
-H "Content-type: application/json" \
-H "DD-API-KEY: $DD_API_KEY" \
-H "DD-APPLICATION-KEY: $DD_APP_KEY" \
-d '{
    "hooks": [
      {
        "name": "Automated_Kill_Stress",
        "url":  "'"http://$HOST:$PORT/$ENDPOINT"'",
        "headers": "{\"token\": \"'$TOKEN'\"}",
        "use_custom_payload": "true",
        "custom_payload": "{\"Content-type\": \"application/json\"}"
      }
    ]
}' \
"https://api.datadoghq.com/api/v1/integration/webhooks"
