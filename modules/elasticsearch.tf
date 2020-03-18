# *********** Variables ***********
variable "vpc" {}

variable "domain" {
  default = "cowork-elasticsearch"
}


# *********** data sources ***********
data "aws_vpc" "vpc-data" {
  id = "${var.vpc}"
}

data "aws_subnet_ids" "subnet-data" {
  vpc_id = "${data.aws_vpc.vpc_data.id}"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# *********** AWS resources ***********
resource "aws_security_group" "sg-elasticsearch" {
  name = "${var.domain}"
  vpc_id = "${data.aws_vpc.vpc-data.id}"

  ingress {
      from_port = "443"
      to_port = "443"
      protocol = "tcp"

      cidr_blocks = [
          "${data.aws_vpc.vpc-data.cidr_blocks}"
      ]
  }
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "cowork-elasticsearch" {
  domain_name = "${var.domain}"
  elasticsearch_version = "7.4"
  
  cluster_config {
      #instance_type = "r5.large.elasticsearch"
      instance_type = "t2.small.elasticsearch"
      dedicated_master_enabled = "true"
      # dedicated_master_type = "r5.large.elasticsearch"
      dedicated_master_type = "t2.small.elasticsearch"
      dedicated_master_count = "3"
      zone_awareness_enabled = "true"

      zone_awareness_config {
        availability_zone_count = "2"
      }
  }

  snapshot_options { 
      automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = "true"
    volume_type = "gp2"
    volume_size = "50"
  }

  vpc_options {
    subnet_ids = [
      "${data.aws_subnet_ids.subnet-data.ids[0]}",
      "${data.aws_subnet_ids.subnet-data.ids[1]}"
    ]

    security_group_ids =  ["${aws_security_group.sg-elasticsearch.id}"] 
  }

  access_policies = <<CONFIG
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "es:*",
        "Principal": "*",
        "Effect": "Allow",
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  depends_on = [
    "${aws_iam_service_linked_role.es}"
  ]

  tags {
      domain = "${var.domain}"
      environment = "${var.environment}"
  }
}

