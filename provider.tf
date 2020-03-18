provider "aws" {
  region = "${var.REIGION["${var.environment}"]}"
}

