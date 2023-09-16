resource "random_id" "random_id" {
  byte_length = 8
}

output "random_id" {
  value = random_id.random_id.hex
}