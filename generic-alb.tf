

resource "aws_lb" "lb" {
  name               = "${var.name}"
  internal           = false
  load_balancer_type = "${var.type}" 
  security_groups    = var.security_groups
  subnets            = ["${var.subnet_ids}"]

  enable_deletion_protection = true

  access_logs {
    bucket  = "${var.log_bucket_name}"
    prefix  = "test-lb"
    enabled = true
  }

  tags {
    Name = "${var.name}"
    environment = "${var.environment}"
    project = "${var.project}"
    owner = "${var.owner}"
  }
}

# Define a listener
resource "aws_alb_listener" "generic" {
  load_balancer_arn = "${aws_alb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default_group.arn}"
    type             = "forward"
  }

  tags {
    Name = "${var.name}"
    environment = "${var.environment}"
    project = "${var.project}"
    owner = "${var.owner}"
  }
}


resource "aws_lb_target_group" "default_group" {
  name     = "${var.environment}-${var.project}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags = {
    Name = "${var.name}"
    environment = "${var.environment}"
    project = "${var.project}"
    owner = "${var.owner}"
  }
}
