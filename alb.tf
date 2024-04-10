resource "aws_lb" "ecs_alb_ttt" {
  name               = "ecs-alb-ttt"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.allow_web.id]
  tags = {
    Name = "ecs-alb-ttt"
  }
#  enable_deletion_protection = false
#  depends_on = [aws_eip.static_ip]
#  ip_address_type = "ipv4"
#  load_balancer_ip = aws_eip.static_ip.public_ip
}
resource "aws_lb_target_group" "ecs_tg_ttt" {
  name        = "ecs-target-group-ttt"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.prod-vpc.id

}
resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb_ttt.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_ttt.arn
  }
}


resource "aws_lb" "ecs_alb_ttt_2" {
  name               = "ecs-alb-ttt-2"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.allow_web.id]
  tags = {
    Name = "ecs-alb-ttt-2"
  }
  #  enable_deletion_protection = false
  #  depends_on = [aws_eip.static_ip]
  #  ip_address_type = "ipv4"
  #  load_balancer_ip = aws_eip.static_ip.public_ip
}
resource "aws_lb_target_group" "ecs_tg_ttt_2" {
  name        = "ecs-target-group-ttt-2"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.prod-vpc.id

}
resource "aws_lb_listener" "ecs_alb_listener_2" {
  load_balancer_arn = aws_lb.ecs_alb_ttt_2.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_ttt_2.arn
  }
}
#resource "aws_eip" "static_ip" {
#  domain = "vpc"
#}










output "load_balancer_ip" {
  value = aws_lb.ecs_alb_ttt.dns_name
}
output "nlb_dns_name" {
  value = aws_lb.ecs_alb_ttt.dns_name
}

#output "nlb_elastic_ip" {
#  value = aws_eip.static_ip.public_ip
#}