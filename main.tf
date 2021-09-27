locals {
  lacework_audit_policy_name = (
    length(var.lacework_audit_policy_name) > 0 ? var.lacework_audit_policy_name : "lwaudit-policy-${random_id.uniq.hex}"
  )
}

resource "random_id" "uniq" {
  byte_length = 4
}

resource "aws_iam_role_policy_attachment" "security_audit_policy_attachment" {
  role       = var.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Lacework custom configuration policy
data "aws_iam_policy_document" "lacework_audit_policy" {
  version = "2012-10-17"

  statement {
    sid       = "GetEbsEncryptionByDefault"
    actions   = ["ec2:GetEbsEncryptionByDefault"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lacework_audit_policy" {
  name        = local.lacework_audit_policy_name
  description = "An audit policy to allow Lacework to read configs (extends SecurityAudit)"
  policy      = data.aws_iam_policy_document.lacework_audit_policy.json
}

resource "aws_iam_role_policy_attachment" "lacework_audit_policy_attachment" {
  role       = var.iam_role_name
  policy_arn = aws_iam_policy.lacework_audit_policy.arn
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_time" {
  create_duration = var.wait_time
  depends_on = [
    aws_iam_role_policy_attachment.security_audit_policy_attachment,
    aws_iam_role_policy_attachment.lacework_audit_policy_attachment,
  ]
}

resource "lacework_integration_aws_cfg" "default" {
  name = var.lacework_integration_name
  credentials {
    role_arn    = var.iam_role_arn
    external_id = var.iam_role_external_id
  }
  depends_on = [time_sleep.wait_time]
}
