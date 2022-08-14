resource "aws_security_group" "allow-postgresql" {
  name        = "allow-aurora-postgresql"
  description = "Allow Postgresql connection"
  vpc_id      = "vpc-0e572975" #Add here your VPC ID

  ingress {
    description      = "Postgresql from VPC"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "PostgresqlAurora"
  }
}






resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"  
  engine_mode             = "serverless"  
  database_name           = var.db_name  
  enable_http_endpoint    = true  
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 7
  apply_immediately = true
  skip_final_snapshot     = true

  vpc_security_group_ids = [
    aws_security_group.allow-postgresql.id,
  ]

  scaling_configuration {
  auto_pause               = true
  min_capacity             = 2    
  max_capacity             = 384
  seconds_until_auto_pause = 300
  timeout_action           = "ForceApplyCapacityChange"
  }  

  tags = {
    Name = "My aurora demo cluster"
    component = "database"
  }

}