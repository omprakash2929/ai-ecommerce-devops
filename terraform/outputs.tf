output "public_ip" {
  description = "Public IP of the server"
  value       = module.compute.public_ip
}

output "ssh_command" {
  description = "SSH into the server"
  value       = "ssh -i ~/.ssh/nexvion-key ubuntu@${module.compute.public_ip}"
}

output "ansible_inventory_line" {
  description = "Paste into ansible/inventory.ini under [aws]"
  value       = "nexvion-aws ansible_host=${module.compute.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/nexvion-key"
}

output "app_url" {
  value = "http://${module.compute.public_ip}:30080"
}

output "jenkins_url" {
  value = "http://${module.compute.public_ip}:8080"
}

output "grafana_url" {
  value = "http://${module.compute.public_ip}:32000"
}
