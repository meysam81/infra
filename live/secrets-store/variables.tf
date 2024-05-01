variable "parameters" {
  type = list(object({
    name        = string
    value       = string
    description = optional(string)
    secure      = bool
  }))
  default = []
}

variable "tags" {
  type = map(string)
  default = {
    Owner       = "meysam"
    Environment = "prod"
  }
}
