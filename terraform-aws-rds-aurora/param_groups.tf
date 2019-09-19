resource "aws_db_parameter_group" "db_param_group" {
  name        = "${var.name}-db-instance-pg"
  family      = "${var.family}"
  description = "automic db postgres10 parameter group"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_lock_waits"
    value = "on"
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "300000"
  }

  parameter {
    name  = "pg_stat_statements.track_utility"
    value = "on"
  }

  parameter {
    name  = "random_page_cost"
    value = "1.0"
  }
}

resource "aws_rds_cluster_parameter_group" "db_cluster_pg" {
  name        = "${var.name}-cluster-pg"
  family      = "${var.family}"
  description = "automic db cluster postgres10 parameter group"

  parameter {
    name  = "autovacuum_vacuum_cost_delay"
    value = "0"
  }

  parameter {
    name  = "vacuum_cost_limit"
    value = "10000"
  }

  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.01"
  }

  parameter {
    name  = "autovacuum_naptime"
    value = "60"
  }

  parameter {
    name  = "client_encoding"
    value = "LATIN1"
  }
}
