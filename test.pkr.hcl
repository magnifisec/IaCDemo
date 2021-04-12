source "amazon-ebs" "packertest" {
  instance_type = "t2.micro"
  ssh_username = "ubuntu"
  ami_name = "packertestami"
  source_ami_filter {
    filters = {
      name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["099720109477"]
  }
}

build {
  sources = ["source.amazon-ebs.packertest"]
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y",
      "sudo apt install apache2 curl -y",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "git clone https://github.com/magnifisec/website.git /tmp/website",
      "sudo rm -rf /tmp/website/.git",
      "sudo rm -rf /tmp/website/admin",
      "sudo cp -r /tmp/website/* /var/www/html/",
      "sudo rm -rf /tmp/website/",
      "curl http://localhost/"
    ]
  }
}
