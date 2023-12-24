################################################  Computing modules #####################################
resource "aws_eip" "lbeip"{
count = 2
instance = "${element(aws_instance.lbserver.*.id, count.index)}"
vpc = "true"
}


resource "aws_instance" "lbserver" {
count = 2
#availability_zone = "us-east-1c"
ami = "${var.myamiid}"
instance_type = "t2.medium"
subnet_id = "${element(var.lbsubnet, count.index)}"
#private_ip= "10.0.10.6"
vpc_security_group_ids = ["${var.websg}"]
key_name = "${var.mykeypair}"
user_data = "${element(var.user_data["lbserver"], count.index)}"
tags = "${merge(var.tags, map("Name", format("lb-server-%d", count.index + 1)))}"
root_block_device {
  volume_type = "standard"
  volume_size = "9"
  delete_on_termination = "true"
  }
ebs_block_device {
  device_name = "/dev/xvde"
  volume_type = "gp2"
  volume_size = "10"
  }
}

resource "aws_instance" "appserver" {
count = 2
#availability_zone = "us-east-1c"
ami = "${var.myamiid}"
instance_type = "t2.medium"
subnet_id = "${var.enable_user_defined_ips ? element(var.appsubnet, element(split(":", element(var.appserver_pa_ips, count.index)),1)) : element(var.appsubnet, count.index)}"
private_ip = "${var.enable_user_defined_ips ? element(split(":", element(var.appserver_pa_ips, count.index),0)) : ""}"
#private_ip= "10.0.20.6"
vpc_security_group_ids = ["${var.websg}"]
key_name = "${var.mykeypair}"
user_data = "${element(var.user_data["appserver"], count.index)}"
tags = "${merge(var.tags, map("Name", format("app-server-%d", count.index + 1)))}"
}
