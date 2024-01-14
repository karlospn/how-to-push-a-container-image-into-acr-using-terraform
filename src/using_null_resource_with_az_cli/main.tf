# Set container image name
locals {
  image_name = "init-app-null-resource-with-az-cli"
  image_tag = "latest"
}

# Create docker image
resource "null_resource" "docker_image" {
    triggers = {
        image_name = local.image_name
        image_tag = local.image_tag
        registry_name = data.azurerm_container_registry.acr.name
        dockerfile_path = "${path.cwd}/init-app/Dockerfile"
        dockerfile_context = "${path.cwd}/init-app"
        dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "init-app/*") : filesha1(f)]))
    }
    provisioner "local-exec" {
        command = "./scripts/docker_build_and_push_to_acr.sh ${self.triggers.image_name} ${self.triggers.image_tag} ${self.triggers.registry_name} ${self.triggers.dockerfile_path} ${self.triggers.dockerfile_context}" 
        interpreter = ["bash", "-c"]
    }
}

# Create an app service using the recelenty pushed image to ACR
resource "azurerm_linux_web_app" "web_app" {
  name                = "app-demo-null-resource-with-az-cli"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "West Europe"
  service_plan_id     = data.azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    application_stack {
      docker_image_name = "${local.image_name}:${local.image_tag}"
      docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"
    }

    container_registry_use_managed_identity = true
    always_on = true
    ftps_state = "FtpsOnly"
    health_check_path = "/health"
  }

  app_settings = {
    "WEBSITES_PORT" = "8080" 
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
        site_config.0.application_stack    
    ]
  }

  depends_on = [ 
    null_resource.docker_image 
  ]
}

# Add AcrPull role to app service Manage Identity
resource "azurerm_role_assignment" "app_msi_role_assignment" {
    scope                            = data.azurerm_resource_group.rg.id 
    role_definition_name             = "AcrPull"
    principal_id                     = azurerm_linux_web_app.web_app.identity[0].principal_id
}