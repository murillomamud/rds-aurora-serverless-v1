resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"  
  engine_mode             = "serverless"  
  database_name           = var.db_name  
  # enable_http_endpoint    = true  
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 7
  apply_immediately = true
  skip_final_snapshot     = true
  publicly_accessible     = true


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