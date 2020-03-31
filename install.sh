#!/bin/bash

#configure listener
sh create_listener.sh

#configure host for test
sh configure_host_for_test.sh

#create monitors
python create_monitors.py

echo "To clean up, run the following from this directory: python remove_monitors.py\n"
