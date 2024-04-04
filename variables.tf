variable "instance_names" {
    description = "Name og the instances"
    type = set(string)
    default =  [
        "Endpoint-A", 
        "Endpoint-B"
    ]
}