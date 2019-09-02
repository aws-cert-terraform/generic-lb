

resource "aws_lb" "lb" {
  name               = "${var.name}"
  internal           = false
  load_balancer_type = "${var.type}" 
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = "${aws_s3_bucket.alb-log-bucket.bucket}"
    prefix  = "alb-logs"
    enabled = true
  }

}

# Define a listener
resource "aws_alb_listener" "generic" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default_group.arn}"
    type             = "forward"
  }

}

resource "aws_lb_target_group" "default_group" {
  name     = "${var.tags.environment}-${var.tags.project}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}


// This is a built in helper for getting account ids for load balancing
// it exists explicitly for lb whitelisting. For more info:
// https://www.terraform.io/docs/providers/aws/d/elb_service_account.html
data "aws_elb_service_account" "main" {}

/*
Generic Bucket
*/
resource "aws_s3_bucket" "alb-log-bucket" {
  bucket = "${var.name}-alb-logs"
  // acl    = "private"
  // policy = "${var.policy}"
  policy = templatefile("${path.module}/policy-templates/policy.json.tmpl",
    { 
     bucket_name = "${var.name}-alb-logs", 
     prefix = "alb-logs"
     policy_arn = "${data.aws_elb_service_account.main.arn}" 
    }
  )
}
