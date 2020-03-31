import os
from datadog import initialize, api

options = {
    'api_key': os.environ["DD_API_KEY"],
    'app_key': os.environ["DD_APP_KEY"]
}

initialize(**options)

#get instance-id for host
with open('instance-id', 'r') as file:
    instance_id = file.read().replace('\n', '')

#create threshold monitor
data = api.Monitor.create(
    type = "metric alert",
    query = "avg(last_1m):avg:system.cpu.user{host:" + instance_id + "} > 80",
    name = "Automated - CPU is over threshold!"
)

#store id
threshold_monitor_id = data["id"]
threshold_monitor_id = str(threshold_monitor_id)

#create process monitor
data = api.Monitor.create(
    type = "process alert",
    query = "processes('stress').over('host:" + instance_id + "').rollup('count').last('1m') > 0",
    name = "Automated - Stress process detected"
)

#store id
process_monitor_id = data["id"]
process_monitor_id = str(process_monitor_id)

#create composite monitor
data = api.Monitor.create(
    type = "composite",
    query = threshold_monitor_id + " && " + process_monitor_id,
    name = "Automated - Stress Threshold and Process",
    message = "@webhook-Automated_Kill_Stress"
)

#store id
composite_monitor_id = data["id"]
composite_monitor_id = str(composite_monitor_id)

#store id for teardown
monitor_ids_file = os.environ["MONITOR_IDS"]
mode = "a"
f = open(monitor_ids_file, mode)
f.writelines(threshold_monitor_id)
f.writelines("\n")
f.writelines(process_monitor_id)
f.writelines("\n")
f.writelines(composite_monitor_id)
f.writelines("\n")
f.close()
