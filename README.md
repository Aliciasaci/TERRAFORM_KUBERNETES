# Projet DevOps
#### Groupe du projet : 
    - Alicia SACI 5IW1
    - Awa Bah 5IW1

### Terrafom : Déploiement des ressources 
  1. Créer le groupe de ressources dans azure
     - Dans terraform.tfvars, renseigner la location, le resource_groupe ainsi que le nom du compte de stockage :
       ```
        location = "francecentral"
        resource_group = "rg-esgi-alicia-saci"
        storage_account_name = "staliciasaci"
       ```
     - Dans main.tf, créer le groupe de ressources :
       ```
       resource "azurerm_resource_group" "rg_main" {
        name     = var.resource_group
        location = var.location
        tags = {
          environment = "Terraform Lab"
          }
        }
       ```
  2. Créer le registre de conteneur
     - Dans main.tf, créer le register de conteneur avec le nom "registeryaliciasaci". le mettre dans le groupe de ressouces principal avec SKU à standard.
       ```
        resource "azurerm_container_registry" "acr" {
        name                = "registryaliciasaci"
        resource_group_name = azurerm_resource_group.rg_main.name
        location            = azurerm_resource_group.rg_main.location
        sku                 = "Standard"
        admin_enabled       = false
        }
       ```
  3. Créer un kluster Kubeternes
     - Dans main.tf, créer le kluster au nom "cluster_kube". La location et le groupe de ressources sont les mêmes défini dans le terraform.tfvars. Le kluster contient 1 seul node.
       ```
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
      ```
 4. Adresse IP publique
    ```
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
```
    

       
  
  
