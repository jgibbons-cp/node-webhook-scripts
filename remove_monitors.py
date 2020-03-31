import os
from datadog import initialize, api

options = {
    'api_key': os.environ["DD_API_KEY"],
    'app_key': os.environ["DD_APP_KEY"]
}

initialize(**options)

#open file for ids
monitor_ids_file = os.environ["MONITOR_IDS"]
mode = "r"
file = open(monitor_ids_file, mode)
lines = file.readlines()

#delete monitors starting with composite
for line in reversed(lines):
    monitor_id = line.strip('\n')
    api.Monitor.delete(monitor_id)

#close file and delete file
file.close()
os.remove(monitor_ids_file)
os.remove("istance-id")