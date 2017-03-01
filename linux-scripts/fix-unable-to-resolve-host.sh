 #!/bin/bash
 sudo bash -c 'echo "127.0.0.1 localhost ip-10-0-0-`ifconfig eth0 | egrep -o "inet addr:([0-9|\.]+)" | egrep -o "[0-9]+$"`" >> /etc/hosts'
