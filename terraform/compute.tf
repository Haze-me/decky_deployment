data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "solver" {
  key_name   = "${var.project_name}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "aws_instance" "solver" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.solver.key_name
  vpc_security_group_ids = [aws_security_group.solver.id]
  user_data              = file("${path.module}/bootstrap.sh")

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = { Name = "${var.project_name}-k3s" }

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

resource "aws_eip" "solver" {
  domain   = "vpc"
  instance = aws_instance.solver.id
  tags     = { Name = "${var.project_name}-eip" }
}
