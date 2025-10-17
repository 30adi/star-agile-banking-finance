resource "aws_instance" "test-server" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  key_name = "jen_doc"
  vpc_security_group_ids = ["sg-036c1f05808d53b47"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./jen_doc.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook -i inventory /var/lib/jenkins/workspace/finance-server/terraform_files/ansibleplaybook.yml"
     }
  }
