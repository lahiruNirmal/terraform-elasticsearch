
module "elasticsearch_cluster" {
  source = "./es-module"
  vpc = "${var.vpc}"
  environment = "${var.environment}"
}
