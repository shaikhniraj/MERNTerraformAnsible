# Outputs are printed after "terraform apply" and can be re-read anytime with "terraform output".

output "web_public_ip" {
  description = "Public IP of the web server (open http://<this> in a browser)"
  value       = aws_instance.mern_web.public_ip
}

output "web_private_ip" {
  description = "Private IP of the web server (used in the DB firewall rule)"
  value       = aws_instance.mern_web.private_ip
}

output "db_private_ip" {
  description = "Private IP of the DB server (used in MONGO_URI and the inventory)"
  value       = aws_instance.mern_db.private_ip
}

output "ssh_web" {
  description = "Command to SSH into the web server"
  value       = "ssh -i ${trimsuffix(var.public_key_path, ".pub")} ubuntu@${aws_instance.mern_web.public_ip}"
}

output "ssh_db" {
  description = "Command to SSH into the DB server through the web server (jump host)"
  # -J does not pass -i to the jump host, so use ProxyCommand with its own -i
  value       = "ssh -i ${trimsuffix(var.public_key_path, ".pub")} -o ProxyCommand=\"ssh -i ${trimsuffix(var.public_key_path, ".pub")} -W %h:%p ubuntu@${aws_instance.mern_web.public_ip}\" ubuntu@${aws_instance.mern_db.private_ip}"
}
