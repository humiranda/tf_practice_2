data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners      = ["099720109477"]
  most_recent = true
}

resource "aws_security_group" "sg" {
  name = "gmlp-ssh"

  // SSH
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

resource "aws_instance" "instance-1" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.my_private_key_path}")}"
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo apt update",
    ]
  }
}

output "public-ip" {
  value = "${aws_instance.instance-1.public_ip}"
}
