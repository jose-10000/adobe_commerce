

# EC2 instance
resource "aws_instance" "ec2_instance" {

  ami = var.ami_id
  #  count                  = var.number_of_instances
  subnet_id              = aws_subnet.subnet_public.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.rancher-c-sg.id]
  key_name               = aws_key_pair.ec2key.key_name

  root_block_device {

    volume_type           = "gp3"
    volume_size           = var.volume_size
    delete_on_termination = true

  }
  tags = {

    Name      = "Rancher-Server"
    Terraform = "true"

  }

}

# resource "aws_ebs_volume" "ec2_volume" {
#   availability_zone = var.availability_zone
#   size              = var.volume_size
#   type              = "gp3"
#   tags = {
#     Name = "adobe-commerce"
#     Terraform = "true"
#   }
# }


#resource "aws_instance" "ec2_instance2" {
#  ami = var.ami_id
# # count                  = var.number_of_instances
#  subnet_id              = aws_subnet.subnet_public.id
#  instance_type          = var.instance_type2
#  vpc_security_group_ids = [aws_security_group.rancher-c-sg.id]
#  key_name               = aws_key_pair.ec2key.key_name
#
#  root_block_device {
#    volume_type           = "gp3"
#    volume_size           = var.volume_size2
#    delete_on_termination = true
#  }
#  tags = {
#    Name = "Rancher-Node"
#    Terraform = "true"
#  }
#
#}

resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file(var.public_key_path)
}

# It's create an empty resource block, to connect to ec2 by ssh with the user and the key.epm and the public ip
resource "null_resource" "name" {

  # Se usa el .pem y el usuario  para conectarse a la instancia // ssh into the ec2 instance 
  connection {
    type = "ssh"
    user = "admin" # user for debian
    host = aws_instance.ec2_instance.public_ip
  }

  # Copy the installation-script.sh file from your computer to the ec2 instance  
  provisioner "file" {
    source      = "./bash_script"
    destination = "/tmp/"
  }

  # Set permissions and run the installation-script.sh file / para ejecutar el .sh
  provisioner "remote-exec" {
    inline = [

      "sudo chmod +x /tmp/bash_script/00-deploy-debian.sh",
      "bash /tmp/bash_script/00-deploy-debian.sh",

      # "sudo chmod +x /tmp/bash_script/installation-script.sh",
      # "sudo chmod +x /tmp/bash_script/adobe_install.sh",
      # "sudo chmod +x /tmp/bash_script/mysql_config.sh",
      # "sh /tmp/bash_script/installation-script.sh",
    ]
  }

  # Se espera a que se cree // wait for ec2 to be created
  depends_on = [aws_instance.ec2_instance]
}

# It's create an empty resource block, to connect to ec2 by ssh with the user and the key.epm and the public ip
#resource "null_resource" "name" {
#
#  # Se usa el .pem y el usuario  para conectarse a la instancia // ssh into the ec2 instance 
#  connection {
#    type = "ssh"
#    user = "admin" # user for debian
#    host = aws_instance.ec2_instance.public_ip
#  }
#
#  # Copy the installation-script.sh file from your computer to the ec2 instance  
#  provisioner "file" {
#    source      = "./bash_script"
#    destination = "/tmp/"
#  }
#}


