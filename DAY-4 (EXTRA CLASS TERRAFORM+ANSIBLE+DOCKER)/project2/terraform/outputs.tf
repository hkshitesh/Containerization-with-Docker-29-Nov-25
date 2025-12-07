output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "private_key_file" {
  value = local_file.private_key.filename
}
