# Soul6in6Gun_infra
Soul6in6Gun Infra repository

[![Build Status](https://travis-ci.com/otus-devops-2019-02/Soul6in6Gun_infra.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/Soul6in6Gun_infra)

<details><summary>Homework №5, first steps in GCP</summary><p>
Configs of bastion network:

````
bastion_IP = 35.246.220.192
someinternalhost_IP = 10.156.0.3
````

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
</p></details>

<details><summary>Homework №6, cloud-testapp</summary><p>

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
</p></details>
<details><summary>Homework №7, packer</summary><p>
How to start packer:
Edit variables.json (example included) then:
  
````
packer build -var-file=variables.json immutable.json
````
</p></details>
<details><summary>Homework №8, terraform-1</summary><p>

Multiple SSH-keys workaround (WARNING, it deletes all keys that are not in the terraform config):
````
resource "google_compute_project_metadata" "default" {
        metadata {
                ssh-keys = <<EOF
                appuser:${file(var.public_key_path)}
                appuser1:${file(var.public_key_path)}
                appuser2:${file(var.public_key_path)}
        EOF
        }
}
````

Added load balancing config lb.tf
Works as health-checked virtual machine pool balancing with counter variable "count" used as index-name for created multiple VMs and to indicate how many hosts are needed in pool. You can start it with
  
````
terraform apply -var 'count=2' -var-file=terraform.tfvars -auto-approve=true
````

Using separate configurations of each node of pool can result in errors and inconsistency between hosts so don't do that :)
How-to do right way:
In main.tf vm resource config add:
````
resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  count        = "${var.count}"
  machine_type = "g1-small"
  zone         = "${var.region}-${var.zone}"
  ...
````
in variables.tf add:
````
...
variable "count" {
  default = "1"
}
````


<details><summary>lb.tf contents:</summary><p>

````
resource "google_compute_http_health_check" "puma-http-hc" {
  name         = "puma-http-health-check"
  request_path = "/"
  port         = "9292"

  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_target_pool" "puma-target-pool" {
  name = "instance-pool"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.puma-http-hc.self_link}",
  ]
}

resource "google_compute_forwarding_rule" "puma-lb-forwarding-rule" {
  name                  = "puma-lb-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = "${google_compute_target_pool.puma-target-pool.self_link}"
}
````


</p></details>
</p></details>
<details><summary>Homework №9, terraform-2</summary><p>
Made configurations for separate instances for packer (db.jsom, app.json)
  
Same goes for terraform instances 

Made modules and used them in environment setup

Added storage bucket

</p></details>
