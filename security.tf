resource "aws_security_group" "ec2_sg" {
	name = "ec2-tom-sg"
	description = "EC2 SG"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  	ingress {
		from_port = 5000
		to_port = 5000
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	#Allow all outbound
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
tags = {
    Name = "ec2-dev-sg"
  }
}
