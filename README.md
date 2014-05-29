Scp-Block 
=========

Blocking SCP-SFTP exfiltration using iptables

- v 0.1

Tested on CentOs 6.x

Generating rules based on uid and extracting the users from the ssh config file

Creating special chain just for this method

Using the match on packet length to detect SCP/SFTP

See the comments for using ipset for whitelisting special ip addresses

WARNING :

It may reduce console interactivity if the rule is hit
