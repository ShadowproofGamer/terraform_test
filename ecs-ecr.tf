##Define ECR images/repo
#resource "aws_ecr_repository" "frontend-ecr-repo" {
#  name = "new_front"
#}
#resource "aws_ecr_repository" "backend-ecr-repo" {
#  name = "new_back"
#}

# Define ECS cluster
resource "aws_ecs_cluster" "tictactoe_cluster" {
  name = "tictactoe-cluster"
}

# Define ECS task definition for frontend
resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "frontend"
  network_mode             = "awsvpc" #"bridge" #"host" #"awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::139366017033:role/LabRole"
  task_role_arn            = "arn:aws:iam::139366017033:role/LabRole"
  cpu                      = 512
  memory                   = 1024
  container_definitions = jsonencode(
    [
      {
        name : "frontend",
        image : "139366017033.dkr.ecr.us-east-1.amazonaws.com/new_front:latest",
        essential : true,
        memory : 1024,
        cpu : 512,
        portMappings : [
          {
            "containerPort" : 80,
            "hostPort" : 80,
            "protocol" : "tcp"
          }
        ]
      }
  ])
}

# Define ECS task definition for backend
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend"
  network_mode             = "awsvpc" #"bridge" #"host" #"awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::139366017033:role/LabRole"
  task_role_arn            = "arn:aws:iam::139366017033:role/LabRole"
  cpu                      = 512
  memory                   = 1024
  container_definitions = jsonencode(
    [
      {
        name : "backend",
        image : "139366017033.dkr.ecr.us-east-1.amazonaws.com/new_back:latest",
        memory : 1024,
        cpu : 512,
        essential : true,
        portMappings : [
          {
            "containerPort" : 8080,
            "hostPort" : 8080,
            "protocol" : "tcp"
          }
        ]
      }
  ])
}





# Define ECS service for frontend
resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.tictactoe_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg_ttt.arn
    container_name   = aws_ecs_task_definition.frontend_task.family
    container_port   = 80
  }
  network_configuration {
    subnets          = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.allow_web.id]
  }
  #  depends_on = [aws_lb_listener.ecs_alb_listener]
}



# Define ECS service for backend
resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.tictactoe_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg_ttt.arn
    container_name   = aws_ecs_task_definition.backend_task.family
    container_port   = 8080
  }
  network_configuration {
    subnets          = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.allow_web.id]
  }
  #  depends_on = [aws_lb_listener.ecs_alb_listener]

}

# main.tf
#resource "aws_iam_role" "ecsTaskExecutionRole" {
#  name               = "ecsTaskExecutionRole"
#  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
#}
#
#data "aws_iam_policy_document" "assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRole"]
#
#    principals {
#      type        = "Service"
#      identifiers = ["ecs-tasks.amazonaws.com"]
#    }
#  }
#}
#
#resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
#  role       = aws_iam_role.ecsTaskExecutionRole.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}