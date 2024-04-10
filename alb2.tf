resource "aws_eip" "eip_nlb_1a" {
  domain = "vpc"
}

resource "aws_lb" "nlb" {
  name               = "my-project-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.allow_web.id]

  subnet_mapping {
    subnet_id     = aws_subnet.subnet-1.id
    allocation_id = aws_eip.eip_nlb_1a.id
  }

#  subnet_mapping {
#    subnet_id     = aws_subnet.subnet-2.id
#    allocation_id = aws_eip.eip_nlb_1b.id
#  }
}

resource "aws_lb" "alb_internal" {
  name               = "my-project-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}

resource "aws_lb_target_group" "alb_internal_http" {
  name                 = "ecs-alb-internal-http"
  port                 = 80
  protocol             = "TCP"
  target_type          = "alb"
  preserve_client_ip   = "true"
  ip_address_type      = "ipv4"
  vpc_id               = aws_vpc.prod-vpc.id
}

resource "aws_lb_target_group_attachment" "alb_internal_http" {
  target_group_arn = aws_lb_target_group.alb_internal_http.arn
  target_id        = aws_lb.alb_internal.arn
  port             = 80
}

resource "aws_lb_listener" "nlb_http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_internal_http.arn
  }
}

resource "aws_lb_listener" "http-internal" {
  load_balancer_arn = aws_lb.alb_internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type  = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

#resource "aws_lb_listener_rule" "http_test_internal" {
#  listener_arn = aws_lb_listener.http-internal.arn
#
#  action {
#    target_group_arn = aws_lb_target_group.alb_internal_http
#    type             = "forward"
#  }
#
#  condition {
#    host_header {
#      values = ["vpc"]
#    }
#  }
#}