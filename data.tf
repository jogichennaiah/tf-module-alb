# Reads the information from the remote statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "b55-terraform-bucket"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region  = "us-east-1" 
  }
}


# Creates Listerner For the Private ALB

# This creates the listener and adds to the private ALB
resource "aws_lb_listener" "private" {
  count             = var.INTERNAL ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}