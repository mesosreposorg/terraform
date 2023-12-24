resource "aws_db_instance" "mysqldb" {
  count = "${var.rds_mysql_db["recover"] ? 0 : 1}"
  identifier           = "mysqldb"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "cloudstones"
  username             = "cloud"
  password             = "Stones_123"
  db_subnet_group_name = "${var.mydbsubnetgroup}"
  vpc_security_group_ids = ["${var.websg}"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
#  tags={
#  Name = "mydb"
#  }
}
resource "aws_db_instance" "mysqldbr" {
  count = "${var.rds_mysql_db["recover"] ? length(split(",", var.rds_mysql_db["snapshot_names"])): 0}"
  identifier           = "mysqldbr"
  snapshot_identifier  = "${element(split(",", var.rds_mysql_db["snapshot_names"]), count.index)}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "cloudstones"
  username             = "cloud"
  password             = "Stones_123"
  db_subnet_group_name = "${var.mydbsubnetgroup}"
  vpc_security_group_ids = ["${var.websg}"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
#  tags={
#  Name = "mydb"
#  }
}
