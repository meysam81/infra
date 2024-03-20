variable "gpg_key_emails" {
  type        = map(string)
  description = "A key value pair of email to title for each GPG key"
  default     = {}
}

variable "gpg_key_passphrase" {
  description = "The passphrase to use for the GPG key"
  type        = string
  default     = ""
}

variable "gpg_key_rsa_bits" {
  description = "The number of bits to use for the RSA key"
  type        = number
  default     = 2048
  validation {
    condition     = var.gpg_key_rsa_bits >= 2048
    error_message = "The RSA key must be at least 2048 bits"
  }
}
