variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "us-west1"
}

variable zone {
  description = "Zone"
  default     = "b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for provisioner ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable "count" {
  default = "1"
}
