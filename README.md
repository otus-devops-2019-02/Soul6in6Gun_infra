# Soul6in6Gun_infra
Soul6in6Gun Infra repository

Configs of bastion network:

bastion_IP = 35.246.220.192
someinternalhost_IP = 10.156.0.3

webUI for pritunl:
https://35.246.220.192.xip.io/

someinternalhost connection shortcut:
````
ssh -t -i ~/.ssh/id_rsa -A soul_in_gun@35.246.220.192 ssh 10.156.0.3
````
Alias way: in ~/.ssh/config paste:
````
Host bastion
User soul_in_gun
HostName 35.246.220.192
ForwardAgent yes
IdentityFile ~/.ssh/id_rsa

Host someinternalhost
User soul_in_gun
HostName 10.156.0.3
ProxyJump bastion
ForwardAgent yes
IdentityFile ~/.ssh/id_rsa
````

