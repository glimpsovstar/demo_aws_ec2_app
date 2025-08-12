# resource "aap_inventory" "vm_inventory" {

#   name        = "Better Together Demo - ${var.TFC_WORKSPACE_ID}"
#   description = "Inventory for VMs built with HCP Terraform and managed by AAP"
# }

# resource "aap_group" "vm_groups" {
#   inventory_id = aap_inventory.vm_inventory.id
#   name         = "vm_groups"
# }

# resource "aap_host" "vm" {
#   inventory_id = aap_inventory.vm_inventory.id
#   name         = var.instance_name_prefix
#   variables = jsonencode(
#     {
#       ansible_host : aws_instance.this.public_ip
#       environment: "development"
#       costcenter: "engineering"
#       owner: "devops-team"
#       purpose: "demo-application"
#       backup: "daily"
#     }
#   )
#   groups = [aap_group.vm_groups.id]
# }

# data "aap_job_template" "create_cr" {
#   name = "Create Standard Change Record"
#   organization_name = "Default"
# }

# resource "aap_job" "create_cr" {
#   job_template_id = data.aap_job_template.create_cr.id
#   # inventory_id    = aap_inventory.vm_inventory.id
#   extra_vars = jsonencode({
#     "TFC_WORKSPACE_ID" = var.TFC_WORKSPACE_ID
#   })
#   wait_for_completion = true
#   wait_for_completion_timeout_seconds = 180
# }

# # data "aap_workflow_job_template" "post_deploy" {
# #   name = "AAP Post Deployment"
# #   organization_name = "Default"
# # }

# resource "aap_workflow_job" "post_deploy" {
#   depends_on = [ aws_instance.this ]
  
#   workflow_job_template_id = data.aap_workflow_job_template.post_deploy.id
#   inventory_id             = aap_inventory.vm_inventory.id
# }