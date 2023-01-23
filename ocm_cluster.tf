locals {
  sts_roles = {
    role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Installer-Role",
    support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Support-Role",
    operator_iam_roles = [
      {
        name      = "cloud-credential-operator-iam-ro-creds",
        namespace = "openshift-cloud-credential-operator",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-cloud-credential-operator-cloud-c",
      },
      {
        name      = "installer-cloud-credentials",
        namespace = "openshift-image-registry",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-image-registry-installer-cloud-cr",
      },
      {
        name      = "cloud-credentials",
        namespace = "openshift-ingress-operator",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-ingress-operator-cloud-credential",
      },
      {
        name      = "ebs-cloud-credentials",
        namespace = "openshift-cluster-csi-drivers",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-cluster-csi-drivers-ebs-cloud-cre",
      },
      {
        name      = "cloud-credentials",
        namespace = "openshift-cloud-network-config-controller",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-cloud-network-config-controller-c",
      },
      {
        name      = "aws-cloud-credentials",
        namespace = "openshift-machine-api",
        role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.operator_role_prefix}-openshift-machine-api-aws-cloud-credentials",
      },
    ]
    instance_iam_roles = {
      master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-ControlPlane-Role",
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Worker-Role"
    },
  }
}

data "aws_caller_identity" "current" {
}

resource "ocm_cluster_rosa_classic" "rosa_sts_cluster" {
  name                 = local.ocm_cluster.name
  cloud_region         = local.region
  aws_account_id       = data.aws_caller_identity.current.account_id
  multi_az             = local.ocm_cluster.multi_az
  compute_nodes        = local.ocm_cluster.compute_nodes
  compute_machine_type = local.ocm_cluster.compute_machine_type
  availability_zones   = local.ocm_cluster.availability_zones
  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }
  sts  = local.sts_roles
}

module "operator_roles" {
  source = "/workspace/module/terraform-provider-ocm/modules/aws_roles/operator_roles"

  cluster_id                  = ocm_cluster_rosa_classic.rosa_sts_cluster.id
  operator_role_prefix        = local.operator_role_prefix
  account_role_prefix         = local.account_role_prefix
  rh_oidc_provider_thumbprint = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
  rh_oidc_provider_url        = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
}
