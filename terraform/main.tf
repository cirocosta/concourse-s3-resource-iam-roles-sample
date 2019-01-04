provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

# Given that this is only a sample, we can make use of
# the default VPC (assuming you didn't delete your default VPC
# in your region, you can too).
data "aws_vpc" "main" {
  default = true
}

# Provide the public key that we want in our instance so we can
# SSH into it using the other side (private) of it.
resource "aws_key_pair" "main" {
  key_name_prefix = "sample-key"
  public_key      = "${file("./keys/key.rsa.pub")}"
}

# Allow SSHing into the instance
resource "aws_security_group" "allow-ssh-and-egress" {
  name = "allow-ssh-and-egress"

  description = "Allows ingress SSH traffic and egress to any address."
  vpc_id      = "${data.aws_vpc.main.id}"

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

  tags {
    Name = "allow_ssh-and-egress"
  }
}

# Create an instance in the default VPC with a specified
# SSH key so we can properly SSH into it to verify whether
# everything is worked as intended.
resource "aws_instance" "main" {
  instance_type        = "c5.xlarge"
  ami                  = "${data.aws_ami.ubuntu.id}"
  key_name             = "${aws_key_pair.main.id}"
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
  ]

  provisioner "file" {
    source      = "./keys/worker-private-key"
    destination = "/worker-private-key"
  }

  provisioner "file" {
    source      = "./keys/tsa-public-key"
    destination = "/tsa-public-key"
  }

  provisioner "file" {
    source      = "./run-worker.sh"
    destination = "/tsa-public-key"
  }

  provisioner "remote-exec" {
    script = "./instance-init.sh"
  }

}

output "public-ip" {
  description = "Public IP of the instance created"
  value       = "${aws_instance.main.public_ip}"
}
