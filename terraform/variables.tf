variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for naming and tags"
  type        = string
  default     = "nexvion"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type (k3s + Jenkins + monitoring needs about 8 GB RAM)"
  type        = string
  default     = "t3.large"
}

variable "root_volume_size" {
  description = "Root disk size in GB"
  type        = number
  default     = 40
}

variable "public_key_path" {
  description = "Path to the SSH public key to upload to AWS"
  type        = string
  default     = "~/.ssh/nexvion-key.pub"
}

variable "admin_cidr" {
  description = "Your public IP in CIDR form (e.g. 203.0.113.10/32). Used for SSH, Jenkins, Grafana, Prometheus, k3s API"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid CIDR and must not be 0.0.0.0/0."
  }
}

variable "app_cidr" {
  description = "Who can reach the public web app (ports 80, 443, 30080)"
  type        = string
  default     = "0.0.0.0/0"
}
