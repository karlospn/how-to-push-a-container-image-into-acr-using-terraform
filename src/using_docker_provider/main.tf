# Set container image name
locals {
  image_name = "init-app-docker-provider:latest"
}

# Create container image
resource "docker_image" "init_app" {
  name = "${data.azurerm_container_registry.acr.login_server}/${local.image_name}"
  keep_locally = false
  
  build {
    no_cache = true
    context = "${path.cwd}/init-app"
  }

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "init-app/*") : filesha1(f)]))
  }

}

# Push container image to ACR
resource "docker_registry_image" "push_image_to_acr" {
  name          = docker_image.init_app.name
  keep_remotely = false
  
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "init-app/*") : filesha1(f)]))
  }
  
}

# Create an app service using the recelenty pushed image to ACR
resource "azurerm_linux_web_app" "web_app" {
  name                = "app-demo-docker-provider"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "West Europe"
  service_plan_id     = data.azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    application_stack {
      docker_image_name = local.image_name
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
    docker_registry_image.push_image_to_acr 
  ]
}

# Add AcrPull role to app service Manage Identity
resource "azurerm_role_assignment" "app_msi_role_assignment" {
    scope                            = data.azurerm_resource_group.rg.id 
    role_definition_name             = "AcrPull"
    principal_id                     = azurerm_linux_web_app.web_app.identity[0].principal_id
}