variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for instances"
  type        = string
  default     = "july2025"
}

variable "user_for_dev_role" {
  default = "arn:aws:iam::457082365292:user/k8s-developer"
}
variable "user_for_admin_role" {
  default = "arn:aws:iam::457082365292:user/k8s-admin"
}

