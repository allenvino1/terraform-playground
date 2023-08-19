terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

variable "output" {
 type = string
 default = "fromVarBlock"
}

resource "local_file" "output_file" {
  content  = "${var.output}"
  filename = "output_file.txt"
}

output "File_Contents" {
  value       = "${local_file.output_file.content}"
  description = "File Content"
}