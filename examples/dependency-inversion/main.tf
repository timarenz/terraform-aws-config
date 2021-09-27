provider "lacework" {}

provider "aws" {}

module "lacework_cfg_iam_role" {
  source = "git::https://github.com/timarenz/terraform-aws-iam-role.git?ref=dependency-inversion"
}

module "aws_config" {
  source = "../../"

  iam_role_arn         = module.lacework_cfg_iam_role.arn
  iam_role_name        = module.lacework_cfg_iam_role.name
  iam_role_external_id = module.lacework_cfg_iam_role.external_id

  lacework_integration_name = "account-abc"
}
