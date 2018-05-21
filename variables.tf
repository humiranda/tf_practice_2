variable "parkey" {
  description = "provide the key that you provide through aws cli command"
  default     = ""
}

variable "my_private_key" {
  description = "provide the path where your ssh private key is"
  default     = "~/.ssh/id_rsa"
}
