# Soul6in6Gun_infra
Soul6in6Gun Infra repository

#Homework №5, first steps in GCP:
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

# Homework №6 cloud-testapp

Server parameters:
````
testapp_IP = 34.76.29.59
testapp_port = 9292
````
Startup script:
````
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata-from-file \
startup-script=startup.sh 
````
Firewall rule adddon:
````
gcloud compute firewall-rules create default-puma-server\
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server
````

