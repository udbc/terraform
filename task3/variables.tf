variable "instance_count" {
  type        = number
  description = "number of instances to launch"
  default     = 1
}

variable "rds_name" {
  type        = string
  description = "database instance identifier"
  default     = "devopsdemo"
}

variable "rds_password" {
  type        = string
  description = "database password"
  sensitive   = true
}

variable "ami" {
  type        = string
  description = "Image ID"
  default     = "ami-02ee763250491e04a"

  validation {
    condition = (
      length(var.ami) > 4 &&
      substr(var.ami, 0, 4) == "ami-"
    )
    error_message = "Please provide a valiid AMI id, starting with \"ami-\"."
  }

}

variable "instance_type" {
  type        = string
  description = "Type of Instance"
  default     = "t2.micro"
}


variable "key_name" {
  type        = string
  description = "SSH Key Pair"
  default     = "terraform"
}


variable "disable_api_termination" {
  type        = bool
  description = "Enable Termination Protection"
  default     = true
}


variable "aws_key_pair" {
  type = object({
    name       = string
    public_key = string
  })
  description = "SSH Key Pair to Create"
  default = {
    name       = "terraform"
    public_key = " "
  }
}

variable "tags" {
  type = object({
    Name       = string
    App        = string
    Maintainer = string
    Role       = string
  })
  description = "SSH Key Pair to Create"
  default = {
    Name       = "tf-frontend-01"
    App        = "devops-demo"
    Maintainer = "Gourav Shah"
    Role       = "frontend"
  }
}

