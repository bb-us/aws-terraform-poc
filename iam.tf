# IAM Role and Policies for ASG
resource "aws_iam_role" "asg_role" {
  name = "asg-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "asg_policy" {
  name        = "asg-policy"
  description = "IAM policy for ASG instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::images/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_role_attachment" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.asg_policy.arn
}

resource "aws_iam_instance_profile" "asg_profile" {
  name = "asg-profile"
  role = aws_iam_role.asg_role.name
}

# IAM Role and Policies for Logs
resource "aws_iam_role" "logs_role" {
  name = "logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "logs_policy" {
  name        = "logs-policy"
  description = "IAM policy for writing to Logs bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::logs/*"
      },
    ]
  })
}
