#Active below code snippet when terraform uses TFC/TFE as environment
data "terraform_remote_state" "base_setup" {
  backend = "remote"
  config = {
    organization = var.tfc_org_name
    workspaces = {
      name = var.tfc_workspace_name_aws_resources
    }
  }
}
#-------------------------------------------------------------------------------------------------------------------
#Reading application cluster info
data "aws_eks_cluster" "app_eks_cluster" {
  name = data.terraform_remote_state.base_setup.outputs.app_cluster_name
}
data "aws_eks_cluster_auth" "app_eks_cluster_auth" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster]
  name       = data.terraform_remote_state.base_setup.outputs.app_cluster_name
}
#Reading blockchain cluster info
data "aws_eks_cluster" "blk_eks_cluster" {
  name = data.terraform_remote_state.base_setup.outputs.blk_cluster_name
}
data "aws_eks_cluster_auth" "blk_eks_cluster_auth" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster]
  name       = data.terraform_remote_state.base_setup.outputs.blk_cluster_name
}
#Reading public hosted zone info
data aws_route53_zone "public_zone" {
  count = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = data.terraform_remote_state.base_setup.outputs.r53_public_hosted_zone_id
}
#Reading private hosted zone info
data aws_route53_zone "private_zone_internal" {
  zone_id = data.terraform_remote_state.base_setup.outputs.r53_private_hosted_zone_internal_id
}
data aws_route53_zone "private_zone" {
  zone_id = data.terraform_remote_state.base_setup.outputs.r53_private_hosted_zone_id
}
