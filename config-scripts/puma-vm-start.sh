#!/bin/bash

gcloud compute instances create reddit-app --tags puma-server --image-family reddit-full --machine-type=f1-micro
