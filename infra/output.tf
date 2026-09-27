output "ecr_repository_url" {
  description = "Push images here in project 4"
  value       = aws_ecr_repository.app.repository_url
}