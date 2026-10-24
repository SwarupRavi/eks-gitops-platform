resource "aws_ecr_repository" "app" {
  name                 = "${var.project}-app"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true # lets terraform destroy remove it even with images inside

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }
}

# Keep only the last 10 images to save storage cost
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}
