provider "aws" {

        access_key = "AKIAVITGXDXK55LFPPN7"
        secret_key  = "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"
        region         = "us-east-2"

}
terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
  }

    backend "s3" {
	bucket = "teamthanos"
	key    = "tomcat/terraform.tfstate"
	region = "us-east-2"
  }
}

resource "aws_instance" "dev_instance" { 
  user_data   = base64encode(file("deploy.sh"))
  ami           = "ami-081c75eaeac28ac34"
  root_block_device {
  volume_type           = "gp2"
  volume_size           = 8
  delete_on_termination = true
  encrypted             = true
  }
  instance_type = "t2.micro"
  key_name = "TeamThanos"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "DEV"
  }
 } 
  
resource "aws_instance" "uat_instance" {
  user_data   = base64encode(file("deploy.sh"))
  ami           = "ami-081c75eaeac28ac34"
  root_block_device {
  volume_type           = "gp2"
  volume_size           = 10
  delete_on_termination = true
  encrypted             = true
  }
  instance_type = "t2.small"
  key_name = "TeamThanos"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "UAT"
  }
 } 
  
resource "aws_instance" "qa_instance" {
  user_data   = base64encode(file("deploy.sh"))
    ami           = "ami-00978328f54e31526"
  instance_type = "t2.large"
  root_block_device {
  volume_type           = "gp2"
  volume_size           = 20
  delete_on_termination = true
  encrypted             = true
  }
  key_name = "TeamThanos"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "QA"
  }
 }
  
resource "aws_instance" "prod_a_instance" {
  user_data   = base64encode(file("deploy.sh"))
  ami           = "ami-081c75eaeac28ac34"
  instance_type = "t2.xlarge"
  root_block_device {
  volume_type           = "gp2"
  volume_size           = 30
  delete_on_termination = true
  encrypted             = true
  }
  key_name = "TeamThanos"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "PROD_A"
  }
}

resource "aws_instance" "prod_b_instance" {
  user_data   = base64encode(file("deploy.sh"))
  ami           = "ami-081c75eaeac28ac34"
  instance_type = "t2.xlarge"
  root_block_device {
  volume_type           = "gp2"
  volume_size           = 30
  delete_on_termination = true
  encrypted             = true
  }
  key_name = "TeamThanos"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "PROD_B"
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-up-and-running-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
