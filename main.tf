module "elasticsearch_cluster" {
  source = "./modules/elasticsearch.tf"
  
  vpc = "${var.vpc}"
}
