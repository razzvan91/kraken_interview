terraform {
  required_version = ">= 0.15"
}

resource "aws_iam_role" "interview-role" {
  name = "interview-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS": var.aws_account_number
        }
      },
    ]
  })

  tags = {
    interview = "true"
  }
}


resource "aws_iam_policy" "interview-policy" {
  name        = "test_policy"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::${var.aws_account_number}:role/interview-role"
      },
    ]
  })
}


resource "aws_iam_group_policy_attachment" "interview-policy-attachment" {
  group      = aws_iam_group.interview-group.name
  policy_arn = aws_iam_policy.interview-policy.arn
}

resource "aws_iam_group" "interview-group" {
  name = "interview-group"
}

resource "aws_iam_user" "interview-user" {
  name = "interview-user"
}

resource "aws_iam_user_group_membership" "interview-group-membership" {
  user = aws_iam_user.interview-user.name
  groups = [
    aws_iam_group.interview-group.name,
  ]
}

#problem 6
#I believe tagging is extremely important

#Documentation for the different resources is available at:
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources