variable "db_user" {
  default = "sardox"

}

variable "container_name" {
  default = "wordpress1"
}

variable "region" {
  default = "eu-central-1"

}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
