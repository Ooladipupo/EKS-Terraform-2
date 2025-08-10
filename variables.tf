variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for instances"
  type        = string
  default     = "july2025"
}

variable "user_for_dev_role" {}
variable "user_for_admin_role" {}