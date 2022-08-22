provider "aws" {
    region = var.region
}

resource "aws_instance" "cp_environment" {
    ami = var.ami_image
    instance_type = var.instance_size   
    key_name = var.key_name
    security_groups = [var.security_group]
    root_block_device {
      volume_type = "gp3"
      volume_size = "100"
    }
    tags = {
            Name = var.instance_name
            Owner = var.instance_owner 
    }
    provisioner "remote-exec" {
      inline = ["echo \"Hello from Terraform\" > ~/hello.txt && sudo apt update"]
    }
  
    connection {
      type = "ssh"
      private_key = "${file(var.private_key)}"
      user        = "${var.ansible_user}"
      host        = self.public_ip
    }
}
  
resource "null_resource" "ansible_run" {
    triggers = {
        always_run = "${timestamp()}"
    }

    depends_on = [aws_instance.cp_environment]

    provisioner "local-exec" {
        command = <<EOT
        if ! command -v ansible &> /dev/null
        then
          echo "ansible could not be found, installing ansible now"
          brew install ansible
        fi
        sleep 30;
        >inventory.ini;
        echo "[cp-environment]" | tee -a inventory.ini;
        echo "${aws_instance.cp_environment.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key}" | tee -a inventory.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i inventory.ini ./playbook.yml
        EOT
   }

#   provisioner "remote-exec" {
#      inline = ["cd cp-demo && ./scripts/start.sh"]
#   }

   connection {
      type = "ssh"
      private_key = "${file(var.private_key)}"
      user        = "${var.ansible_user}"
      host        = "${aws_instance.cp_environment.public_ip}"
   }
}
