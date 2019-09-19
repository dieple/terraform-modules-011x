output "key_name" {
  value = "${data.terraform_remote_state.ssh_key_pair.key_name}"
}

output "private_key_filename" {
  value = "${data.terraform_remote_state.ssh_key_pair.private_key_filename}"
}

output "public_key" {
  value = "${data.terraform_remote_state.ssh_key_pair.public_key}"
}

output "public_key_filename" {
  value = "${data.terraform_remote_state.ssh_key_pair.public_key_filename}"
}
