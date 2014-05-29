#!/bin/bash


### Creating a new chain specific for blocking exfiltration per user using SCP/SFTP

iptables -N exfiltration

### Using the jump to the new chain for every ssh port connection 

iptables -A OUTPUT -p tcp --sport 22 -j exfiltration

### We use this to have an update and hitcount as you will see along the script because it can block console interactivity

iptables -A exfiltration -p tcp --sport 22 -m length --length 1400:65535 -m recent --name scpexf --set

#### Uncomment the following line if you use ipset and change the set name accordingly

#iptables -A exfiltration -m set --set whitelist dst -j ACCEPT


### Extracting the users from ssh config and dumping them on a txt file

cat /etc/ssh/sshd_config | grep AllowUsers | awk '{print $2;}' | grep -v AllowUsers > user-tmp.txt

for i in `cat user-tmp.txt | awk {'print $1'}`;

### Assigning all the user's uid to the variable number

do  number=`cat /etc/passwd | grep $i | cut -d":" -f3 ;`

### Creating the rule

iptables -A exfiltration -p tcp -m owner --uid-owner $number -m recent --name scpexf --update --seconds 8 --hitcount 20 -j REJECT --reject-with tcp-reset

done

