variable "iam_role_arn" {
  type        = string
  description = "The IAM role ARN."
}

variable "iam_role_external_id" {
  type        = string
  description = "The external ID configured inside the IAM role"
}

variable "iam_role_name" {
  type        = string
  description = "The IAM role name."
}

# variable "external_id_length" {
#   type        = number
#   default     = 16
#   description = "The length of the external ID to generate. Max length is 1224. Ignored when use_existing_iam_role is set to `true`"
# }

variable "lacework_aws_account_id" {
  type        = string
  default     = "434813966438"
  description = "The Lacework AWS account that the IAM role will grant access"
}

variable "lacework_integration_name" {
  type        = string
  default     = "TF config"
  description = "The name of the integration in Lacework"
}

variable "lacework_audit_policy_name" {
  type        = string
  default     = ""
  description = "The name of the custom audit policy (which extends SecurityAudit) to allow Lacework to read configs.  Defaults to lwaudit-policy-$${random_id.uniq.hex} when empty"
}

variable "wait_time" {
  type        = string
  default     = "10s"
  description = "Amount of time to wait before the next resource is provisioned"
}

# variable "tags" {
#   type        = map(string)
#   description = "A map/dictionary of Tags to be assigned to created resources"
#   default     = {}
# }
