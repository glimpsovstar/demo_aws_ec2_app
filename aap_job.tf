resource "aap_inventory" "vm_inventory1" {

  name        = "Better Together Demo - ${var.TFC_WORKSPACE_ID}"
  description = "Inventory for VMs built with HCP Terraform and managed by AAP"
}

resource "aap_group" "vm_groups" {
  inventory_id = aap_inventory.vm_inventory1.id
  name         = "vm_groups"
}

resource "aap_host" "sample_foo" {
  inventory_id = aap_inventory.vm_inventory1.id
  name         = "tf_host_foo"
  variables = jsonencode(
    {
      "foo" : "bar"
    }
  )
  groups = [aap_group.vm_groups.id]
}

data "aap_job_template" "create_cr" {
  name = "Create Standard Change Record"
  organization_name = "Default"
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [aap_inventory.vm_inventory1]
  create_duration = "10s"
}

resource "aap_job" "create_cr" {
  depends_on = [ time_sleep.wait_10_seconds ]
  job_template_id = data.aap_job_template.create_cr.id
  inventory_id    = aap_inventory.vm_inventory1.id
  extra_vars = jsonencode({
    "TFC_WORKSPACE_ID" = var.TFC_WORKSPACE_ID
  })
  wait_for_completion = true
  wait_for_completion_timeout_seconds = 180
}

# data "aap_workflow_job_template" "close_cr" {
#   name = "Sample Workflow Job Template"
#   organization_name = "Default"
# }

# resource "aap_workflow_job" "sample_abc" {
#   workflow_job_template_id = data.aap_workflow_job_template.close_cr.id
#   inventory_id             = aap_inventory.my_inventory.id
#   extra_vars               = yamlencode({ "os" : "Linux", "automation" : "ansible" })
# }