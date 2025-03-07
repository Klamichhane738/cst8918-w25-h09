provider "azurerm" {
  features {}
  subscription_id = "b296b604-9c48-4e98-bb66-56c661c39a1d"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "akscluster"

  default_node_pool {
    name              = "default"
    vm_size           = "Standard_B2s"
    node_count        = 1  
    os_disk_size_gb   = 30
    max_pods          = 110
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.30.9" # Updated to a supported version

  tags = {
    environment = "Dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
