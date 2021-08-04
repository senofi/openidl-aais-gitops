resource "aws_iam_role" "eks-cluster-role" {
  for_each = toset(["app-eks", "blk-eks"])
  name = "${local.std_name}-${each.value}"
  assume_role_policy = file("resources/cluster-role-trust-policy.json")
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-${each.value}"
      "Cluster_Type" = "${each.value}"
    },)
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  #role       = aws_iam_role.app-eks-cluster.name
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKS_CNI_Policy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSWorkerNodePolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEC2ContainerRegistryReadOnly" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-cluster-role["${each.value}"].id
}
resource "aws_iam_role" "eks-nodegroup-role" {
  for_each = toset(["app-node-group", "blk-node-group"])
  name = "${local.std_name}-${each.value}"
  assume_role_policy = file("resources/nodegroup-role-trust-policy.json")
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-${each.value}"
      "Cluster_Node_Group" = "${each.value}"
    },)
}
resource "aws_iam_role_policy_attachment" "eks-nodegroup-AmazonEKSWorkerNodePolicy" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-nodegroup-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-nodegroup-AmazonEC2ContainerRegistryReadOnly" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-nodegroup-role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks-nodegroup-AmazonEKS_CNI_Policy" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-nodegroup-role["${each.value}"].id
}
