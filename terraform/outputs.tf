output "public_ip" {
  value = aws_eip.solver.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/solver-lab ubuntu@${aws_eip.solver.public_ip}"
}

output "instance_id" {
  value = aws_instance.solver.id
}
