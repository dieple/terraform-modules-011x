#!/bin/bash

set -e

readonly DEFAULT_LOG_LEVEL="info"
readonly EC2_INSTANCE_METADATA_URL="http://169.254.169.254/latest/meta-data"
readonly SCRIPT_NAME="$(basename "$0")"
readonly AWS_ENV=${aws_env}


function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "$timestamp [$level] [$SCRIPT_NAME] $message"
}

function log_info {
  log "INFO" "$1"
}

function log_warn {
  log "WARN" "$1"
}

function log_error {
  log "ERROR" "$1"
}

function lookup_path_in_instance_metadata {
  local readonly path="$1"
  curl --silent --location "$EC2_INSTANCE_METADATA_URL/$path/"
}

function get_instance_ip_address {
  lookup_path_in_instance_metadata "local-ipv4"
}

function get_instance_id {
  lookup_path_in_instance_metadata "instance-id"
}

function set_host_name {
  local instance_id=""
  log_info "Updating AWS instance hostname"

  instance_id=$(get_instance_id | sed 's/^i-//g')
  hostname="${hostname}-$instance_id"
  hostnamectl set-hostname $hostname
  cat << EOF >> /etc/hosts
  127.0.0.1 $hostname
EOF
}

function start_service {
  log_info "starting $1"
  systemctl start "$1"
}

set_host_name
start_service ${service_name}