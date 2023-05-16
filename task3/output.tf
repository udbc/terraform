output "Hostname" {
  description = "Public Hostname of the Instance"
  value       = aws_instance.frontend.*.public_dns
}

output "IPAddress" {
  description = "Public IP of the Instance"
  value       = aws_instance.frontend.*.public_ip
}

output "SSHKey" {
  description = "SSH Key to Connect to the Instance"
  value       = aws_instance.frontend.*.key_name
}

output "DatabaseEndpoint" {
  description = "RDS Endpoint from Data Source"
  value       = data.aws_db_instance.database.endpoint
}

output "DatabaseEngine" {
  description = "RDS Database Type"
  value       = data.aws_db_instance.database.engine
}

output "Database" {
  description = "Database to connect to"
  value       = data.aws_db_instance.database.db_name
}

output "DatabaseAdminUser" {
  description = "RDS Admin User"
  value       = data.aws_db_instance.database.master_username
}


