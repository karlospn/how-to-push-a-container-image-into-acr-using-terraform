# Create resource group
resource "azurerm_resource_group" "rg" {
    name      = "rg-demo"
    location  = "West Europe"
}

# Create acr
resource "azurerm_container_registry" "acr" {
    name                    = "crdemotf01"
    resource_group_name     = azurerm_resource_group.rg.name
    location                = azurerm_resource_group.rg.location
    sku                     = "Standard"
    admin_enabled           = true
}

# Create app service plan
resource "azurerm_service_plan" "plan" {
  name                = "plan-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B2"
  worker_count        = 1
}

