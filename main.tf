# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Main resource group
resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group
  location = var.location
  tags = {
    environment = "Terraform Lab"
  }
}


# Container registry
resource "azurerm_container_registry" "acr" {
  name                = "registryaliciasaci"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  sku                 = "Standard"
  admin_enabled       = false
}



//*Cluster kubernetes 
resource "azurerm_kubernetes_cluster" "rg_main" {
  name                = "cluster_kube"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  dns_prefix          = "kubecluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

}


#Adresse IP publique
resource "azurerm_public_ip" "aks_public_ip" {
  name                = "aks-public-ip"
  resource_group_name = azurerm_kubernetes_cluster.rg_main.node_resource_group
  location            = azurerm_kubernetes_cluster.rg_main.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Terraform Lab"
  }
}

