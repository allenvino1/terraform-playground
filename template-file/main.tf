terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

variable "name" {
 type = string
 default = "hello!"
}

resource "local_file" "output_file" {
  content  = templatefile("template.tftpl", {
            tfvar = var.name
  })
  filename = "script.sh"
}

