terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

# Latest Ubuntu 22.04 AMI in us-east-1
data "aws_ami" "ubuntu_east" {
  provider    = aws.use1
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Latest Ubuntu 22.04 AMI in us-west-2
data "aws_ami" "ubuntu_west" {
  provider    = aws.usw2
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "east_instance" {
  provider      = aws.use1
  ami           = data.aws_ami.ubuntu_east.id
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu-East"
  }
}

resource "aws_instance" "west_instance" {
  provider      = aws.usw2
  ami           = data.aws_ami.ubuntu_west.id
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu-West"
  }
}
