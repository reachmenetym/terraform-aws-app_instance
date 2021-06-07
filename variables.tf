variable "instance_count" {
    type = number 
}

variable "provision_app" {
    
}

variable "instance_type" {

}

variable "ami_id" {

}

variable "app_volume" {
    default = {
        volume_size = 10
        volume_type = "gp2"
        device_name = "/dev/sda1"
    }
    type = map
}

variable "ssh_key_name" {

}

variable "userdatab64" {
    
}

variable "vpc_id" {
  
}