#!/usr/bin/env bash

########################################
## Uncomment if running standalone.
########################################
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
#echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
#sudo apt-get -y update
#sudo apt-get -y upgrade
########################################

sudo apt-get install -y --allow-unauthenticated mongodb-org

echo -e "[Unit]\nDescription=High-performance, schema-free document-oriented database\nAfter=network.target\n\n[Service]\nUser=mongodb\nExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/mongodb.service
echo -e "#!/bin/sh\n### BEGIN INIT INFO\n# Provides:          disable-transparent-hugepages\n# Required-Start:    $local_fs\n# Required-Stop:\n# X-Start-Before:    mongod mongodb-mms-automation-agent\n# Default-Start:     2 3 4 5\n# Default-Stop:      0 1 6\n# Short-Description: Disable Linux transparent huge pages\n# Description:       Disable Linux transparent huge pages, to improve\n#                    database performance.\n### END INIT INFO\ncase $1 in\n  start)\n    if [ -d /sys/kernel/mm/transparent_hugepage ]; then\n      thp_path=/sys/kernel/mm/transparent_hugepage\n    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then\n      thp_path=/sys/kernel/mm/redhat_transparent_hugepage\n    else\n      return 0\n    fi\n    echo 'never' > ${thp_path}/enabled\n    echo 'never' > ${thp_path}/defrag\n    unset thp_path\n    ;;\nesac" > /etc/init.d/disable-transparent-hugepages

sudo chmod 755 /etc/init.d/disable-transparent-hugepages

sudo update-rc.d disable-transparent-hugepages defaults

sudo systemctl start mongodb
sudo systemctl enable mongodb
