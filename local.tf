locals {
  cluster_name = "rosa-demo-123"

  operator_role_prefix = "ManagedOpenShift"
  account_role_prefix  = "ManagedOpenShift"

  ocm_cluster = {
    name                 = local.cluster_name
    multi_az             = true
    compute_nodes        = 3
    compute_machine_type = "m5.xlarge"
    availability_zones = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
    ]
  }
}
