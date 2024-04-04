variable "instance_names" {
  description = "Name og the instances"
  type        = set(string)
  default = [
    "Endpoint-A",
    "Endpoint-B"
  ]
}

variable  "ami_id" {
    type = string
    default = "ami-019f9b3318b7155c5"
}