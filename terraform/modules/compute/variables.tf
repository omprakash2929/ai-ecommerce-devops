variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "public_key" {
  type = string
}

variable "admin_cidr" {
  type = string
}

variable "app_cidr" {
  type = string
}
