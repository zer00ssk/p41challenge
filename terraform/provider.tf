terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}


# Provider block for Azure

provider "azurerm" {
  #skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  client_id = var.azure-client-id
  subscription_id = var.azure-subscription
  tenant_id = var.azure-tenant
  client_secret = var.azure-client-secret
}

Provider Block for Kubernetes. Takes values from the azurerm_kubernetes_cluster resource block from main.tf
provider "kubernetes" {
  host = azurerm_kubernetes_cluster.tf-aks-cls.kube_config.0.host
  client_certificate = base64decode(azurerm_kubernetes_cluster.tf-aks-cls.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.tf-aks-cls.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.tf-aks-cls.kube_config.0.cluster_ca_certificate)
}
