variable my_eks_cluster {
  type        = string
}


variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}
