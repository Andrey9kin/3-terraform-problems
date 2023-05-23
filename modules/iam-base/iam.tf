module "ssm_agent" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.19.0"

  create_role = true

  role_name         = "ssm-agent-for-ec2"
  role_description  = "Allows runing AWS SSM agent on EC2 instance"
  role_requires_mfa = false

  custom_role_policy_arns = [data.aws_iam_policy.ssm.arn]

  trusted_role_services = ["ec2.amazonaws.com"]
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}