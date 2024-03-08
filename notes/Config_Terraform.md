# Konfigurera VM med Terraform

### Beskrivning i Terraform koden

```bash
# main.tf

provider "aws" {
  region = "eu-north-1" # Bestäm region (Stockholm)
}

# Skapa ett Virtual Private Network
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
  key_name      = "dennis_akind" # Pushar publik nyckel som matchas i AWS-Cloud

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

```

Cloud config - script som konfigurerar installation av program som behövs

```bash
#cloud-config

package_upgrade: true
packages:
  - python3-pip
  - ansible
  - apache2
  - docker.io

runcmd:
  - sudo ansible-pull -U https://github.com/aCybernomad/ansible_cicd -d /home/ansible-pull playbook.yml
  - echo "hello dennis" | sudo tee /var/www/html/index.html
  - systemctl restart apache2
```

```js
Från koden ovan:
Använder Ansibels inbyggda modul för att koppla upp sig mot Github och dra ner playbook.yml (etc) kör även playbooken automatiskt.

sudo ansible-pull -U https://github.com/aCybernomad/ansible_cicd -d /home/ansible-pull playbook.yml
```

### Fixar i AWS för smidighet

```js
"dennis_akind" används som alias för den publika nyckeln "ed25519.pub"

key_name      = "dennis_akind" # Pushar publik nyckel som matchas i AWS-Cloud
```

### Tail: loggar för "cloud config" (På den nyskapade servern)

```bash
tail -f /var/log/cloud-init-output.log
```
