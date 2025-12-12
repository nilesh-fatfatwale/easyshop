data "aws_ami" "os_image" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter { 
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}

resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow TLS"
  description = "Allow user to connect"
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      { description = "port 22 allow", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { description = "port 80 allow", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { description = "port 443 allow", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { description = "port 8080 allow", from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { description = "port 9000 allow", from_port = 9000, to_port = 9000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ]
    content {

      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks

    }
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "InstanceSecuritGroup"
  }
}

resource "aws_instance" "bastion_host" {
  ami             = data.aws_ami.os_image.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data       = file("${path.module}/install_tools.sh")
  tags = {
    Name = "Jenkins-k8s-Automate"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
} 

resource "aws_eip" "jenkins_server_ip" {
  instance = aws_instance.bastion_host.id
  domain   = "vpc"
}
