resource "aap_inventory" "vm_inventory" {

  name        = "Better Together Demo - ${var.TFC_WORKSPACE_ID}"
  description = "Inventory for VMs built with HCP Terraform and managed by AAP"
}

resource "aap_group" "vm_groups" {
  inventory_id = aap_inventory.vm_inventory.id
  name         = "vm_groups"
}

resource "aap_host" "sample_foo" {
  inventory_id = aap_inventory.vm_inventory.id
  name         = "tf_host_foo"
  variables = jsonencode(
    {
      "foo" : "bar"
    }
  )
  groups = [aap_group.vm_groups.id]
}