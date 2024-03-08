# main.tf

provider "aws" {
  region = "eu-north-1" # Betsäm region
}

# Skapa en VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Skapa en Security Group
resource "aws_security_group" "my_security_group" {
  name        = "security-group"
  description = "Allow inbound traffic on ports 80 and 22"

  vpc_id = aws_vpc.my_vpc.id

  # Portar som skall vara öppna
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Skapa en EC2 instance 
resource "aws_instance" "my_instance" {
  ami           = "ami-0014ce3e52359afbd" # AMI ID för vald region 
  instance_type = "t3.micro"
  key_name      = "dennis_akind"

  user_data                   = file("script.yml")
  user_data_replace_on_change = true # Om user data ändras = ny maskin 
  tags = {
    Name        = "Akind CICD"
    Environment = "Dev"
  }
}

output "fqdn" {
  value = aws_instance.my_instance.public_dns
}
