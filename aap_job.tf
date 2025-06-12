resource "aap_inventory" "vm_inventory" {

  name        = "Better Together Demo - ${var.TFC_WORKSPACE_ID}"
  description = "Inventory for VMs built with HCP Terraform and managed by AAP"
}

