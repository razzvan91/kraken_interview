output "aws_iam_user_id" {
  value = aws_iam_user.interview-user.name
}

output "aws_iam_user_arn" {
  value = aws_iam_user.interview-user.arn
}
