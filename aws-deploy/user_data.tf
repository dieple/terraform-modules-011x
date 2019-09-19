#####################
# USER_DATA Template
#####################
data "template_file" "user_data_script" {
  template = "${file("${path.module}/template/user-data.sh")}"

  vars {
    region   = "${var.region}"
    aws_env  = "${var.stage}"
    hostname = "${module.label.short_id}"
  }
}
