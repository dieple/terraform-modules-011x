provider "aws" {
  region = "eu-west-1"
}

data "aws_kms_secrets" "aurora" {
  secret {
    name    = "master_password"
    payload = "${var.master_password}"
  }

  secret {
    name    = "master_username"
    payload = "${var.master_username}"
  }
}

locals {
  port            = "${var.port == "" ? "${var.engine == "aurora-postgresql" ? "5432" : "3306"}" : var.port}"
  master_password = "${var.password == "" ? random_id.master_password.b64 : var.password}"
}

# Random string to use as master password unless one is specified
resource "random_id" "master_password" {
  byte_length = 10
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.name}"
  description = "For Aurora cluster ${var.name}"
  subnet_ids  = ["${var.subnets}"]

  tags = "${merge(var.tags, map("Name", "aurora-${var.name}"))}"
}

resource "aws_rds_cluster" "this" {
  global_cluster_identifier           = "${var.global_cluster_identifier}"
  cluster_identifier                  = "${var.name}"
  engine                              = "${var.engine}"
  engine_mode                         = "${var.engine_mode}"
  engine_version                      = "${var.engine_version}"
  kms_key_id                          = "${var.kms_key_id}"
  database_name                       = "${var.database_name}"
  master_password                     = "${data.aws_kms_secrets.aurora.plaintext["master_password"]}"
  master_username                     = "${data.aws_kms_secrets.aurora.plaintext["master_username"]}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${var.name}-${random_id.snapshot_identifier.hex}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  deletion_protection                 = "${var.deletion_protection}"
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.preferred_backup_window}"
  preferred_maintenance_window        = "${var.preferred_maintenance_window}"
  port                                = "${local.port}"
  db_subnet_group_name                = "${aws_db_subnet_group.this.name}"
  vpc_security_group_ids              = ["${var.vpc_security_group_ids}"]
  snapshot_identifier                 = "${var.snapshot_identifier}"
  storage_encrypted                   = "${var.storage_encrypted}"
  apply_immediately                   = "${var.apply_immediately}"
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.db_cluster_pg.id}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  enabled_cloudwatch_logs_exports     = "${var.enabled_cloudwatch_logs_exports}"

  tags = "${var.tags}"
}

resource "aws_rds_cluster_instance" "this" {
  count = "${var.replica_scale_enabled ? var.replica_scale_min : var.replica_count}"

  identifier                      = "${var.name}-${count.index + 1}"
  cluster_identifier              = "${aws_rds_cluster.this.id}"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${var.instance_type}"
  publicly_accessible             = "${var.publicly_accessible}"
  db_subnet_group_name            = "${aws_db_subnet_group.this.name}"
  db_parameter_group_name         = "${aws_db_parameter_group.db_param_group.id}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  apply_immediately               = "${var.apply_immediately}"
  monitoring_role_arn             = "${var.monitoring_role_arn}"
  monitoring_interval             = "${var.monitoring_interval}"
  auto_minor_version_upgrade      = "${var.auto_minor_version_upgrade}"
  promotion_tier                  = "${count.index + 1}"
  performance_insights_enabled    = "${var.performance_insights_enabled}"
  performance_insights_kms_key_id = "${var.performance_insights_kms_key_id}"

  tags = "${var.tags}"
}

resource "random_id" "snapshot_identifier" {
  keepers = {
    id = "${var.name}"
  }

  byte_length = 4
}

resource "aws_appautoscaling_target" "read_replica_count" {
  count = "${var.replica_scale_enabled ? 1 : 0}"

  max_capacity       = "${var.replica_scale_max}"
  min_capacity       = "${var.replica_scale_min}"
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count" {
  count = "${var.replica_scale_enabled ? 1 : 0}"

  name               = "target-metric"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    scale_in_cooldown  = "${var.replica_scale_in_cooldown}"
    scale_out_cooldown = "${var.replica_scale_out_cooldown}"
    target_value       = "${var.replica_scale_cpu}"
  }

  depends_on = ["aws_appautoscaling_target.read_replica_count"]
}
