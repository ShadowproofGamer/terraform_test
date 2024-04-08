resource "aws_lb" "ecs_alb_ttt" {
  name               = "ecs-alb-ttt"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.allow_web.id]
  tags = {
    Name = "ecs-alb-ttt"
  }
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
resource "aws_lb_listener" "ecs_alb_listener-2" {
  load_balancer_arn = aws_lb.ecs_alb_ttt.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_ttt.arn
  }
}
output "load_balancer_ip" {
  value = aws_lb.ecs_alb_ttt.dns_name
}