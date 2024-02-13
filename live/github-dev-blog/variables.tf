variable "gpg_key_name" {
  description = "The name of the GPG key"
  type        = string
  nullable    = false
}

variable "gpg_key_email" {
  description = "The email address associated with the GPG key"
  type        = string
  nullable    = false
}

variable "gpg_key_passphrase" {
  description = "The passphrase to use for the GPG key"
  type        = string
  nullable    = false
}

variable "gpg_key_rsa_bits" {
  description = "The number of bits to use for the RSA key"
  type        = number
  default     = 3072
  validation {
    condition     = var.gpg_key_rsa_bits >= 2048
    error_message = "The RSA key must be at least 2048 bits"
  }
}

variable "repository" {
  description = "The name of the repository"
  type        = string
  nullable    = false
}
