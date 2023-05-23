resource "aws_appmesh_mesh" "mesh" {
  count = var.create_resources ? 1 : 0
  name  = local.namespace
  tags  = var.tags

  spec {
    egress_filter {
      type = "ALLOW_ALL"
    }
  }
}

data "aws_appmesh_mesh" "mesh" {
  count = var.create_resources ? 0 : 1
  name  = local.namespace
}

output "app_mesh_name" {
  value = var.create_resources ? aws_appmesh_mesh.mesh[0].name : data.aws_appmesh_mesh.mesh[0].name
}

output "app_mesh_arn" {
  value = var.create_resources ? aws_appmesh_mesh.mesh[0].arn : data.aws_appmesh_mesh.mesh[0].arn
}


