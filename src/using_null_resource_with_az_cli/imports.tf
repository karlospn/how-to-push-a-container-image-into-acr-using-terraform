data "azurerm_resource_group" "rg" {
  name = "rg-demo"
}

data "azurerm_container_registry" "acr" {
  name                = "crdemotf01"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_service_plan" "plan" {
  name                = "plan-demo"
  resource_group_name = data.azurerm_resource_group.rg.name
}