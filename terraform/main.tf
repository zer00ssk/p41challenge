/* Terraform code For Task 2 of Particle41 DevOps Challenge. 

The resources are created Azure. AKS is created for deploying the Docker Image created in the previous task. 
List of resources created: 
1. Resouce Groups - one each for AKS, AKS node pool and VNET.
2. VNET
3. 2 Network Security Groups (NSG) - one each for Public and Private network
4. 2 Public Subnets
5. 2 Private Subnets
6. AKS Cluster - Managed Cluster
7. Kubernetes Deployment - Docker image created in the previous task along with public internet facing Load Balancing.

*/



resource "azurerm_resource_group" "testrg" {
  name      = var.rg_name
  location  = var.location
  tags      = {
    environment = var.env
    time_created = timestamp()
  }
}

resource "azurerm_resource_group" "vnet-rg" {
  name       = var.vnet-rg-name
  location   = var.location
  tags        = {
    environment = var.env
    time_created = timestamp()
  }
}

// resource "azurerm_resource_group" "aks-np-rg" {
//   name       = var.aks-np-rg-name
//   location   = var.location
//   tags        = {
//     environment = var.env
//     time_created = timestamp()
//   }
// }

resource "azurerm_virtual_network" "test-vnet" {
  name                  = var.vnet-name
  location              = azurerm_resource_group.vnet-rg.location
  resource_group_name   = azurerm_resource_group.vnet-rg.name
  address_space         = ["10.0.0.0/16"]

  tags = {
    environment = var.env
    time_created = timestamp()
  }
  depends_on = [azurerm_resource_group.vnet-rg]
}

resource "azurerm_subnet" "public-subnet" {
  count = 2
  
  name = "${var.vnet-name}-public-subnet${count.index + 1}"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefixes = ["10.0.${count.index + 1}.0/28"]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_subnet" "private-subnet" {
  count = 2
  
  name = "${var.vnet-name}-private-subnet${count.index + 3}"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefixes = ["10.0.${count.index + 3}.0/28"]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}


resource "azurerm_network_security_group" "test-private-nsg" {
  name                  = var.nsg-name-private
  location              = azurerm_resource_group.testrg.location
  resource_group_name   = azurerm_resource_group.vnet-rg.name
  tags                  = {
    environment         = var.env
    time_created        = timestamp()
  }
  depends_on            = [azurerm_resource_group.vnet-rg]
}


resource "azurerm_network_security_rule" "Deny-all" {
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.test-private-nsg.name

  name                        = "Deny-all"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  depends_on = [azurerm_virtual_network.test-vnet]
}


resource "azurerm_network_security_group" "test-public-nsg" {
  name                  = var.nsg-name-public
  location              = azurerm_resource_group.testrg.location
  resource_group_name   = azurerm_resource_group.vnet-rg.name
  tags                  = {
    environment         = var.env
    time_created        = timestamp()
  }
  depends_on            = [azurerm_resource_group.vnet-rg]
}


resource "azurerm_network_security_rule" "allow-internet-https" {
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.test-public-nsg.name

  name                        = "allow-internet-https"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  depends_on = [azurerm_virtual_network.test-vnet]
}

resource "azurerm_network_security_rule" "allow-internet-http" {
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.test-public-nsg.name

  name                        = "allow-internet-http"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  depends_on = [azurerm_virtual_network.test-vnet]
}

resource "azurerm_subnet_network_security_group_association" "private-subnet-associate" {
  count = 2

  subnet_id                 = element(azurerm_subnet.private-subnet.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.test-private-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "public-subnet-associate" {
  count = 2

  subnet_id                 = element(azurerm_subnet.public-subnet.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.test-public-nsg.id
}

resource "azurerm_kubernetes_cluster" "tf-aks-cls" {
  name = var.aks-name
  location = azurerm_resource_group.testrg.location
  resource_group_name   = azurerm_resource_group.testrg.name
  dns_prefix = "p41aks"
  node_resource_group = var.aks-np-rg-name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2as_v4"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

  }

  identity {
    type = "SystemAssigned"
  }
  
  tags = {
    environment = var.env
    time_created = timestamp()
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks-cluster-node-pool"  {
  count = 1

  kubernetes_cluster_id = azurerm_kubernetes_cluster.tf-aks-cls.id
  name = "npmain1"
  node_count = 1
  vm_size = "Standard_D2as_v4"
  // vnet_subnet_id = element(azurerm_subnet.private-subnet.*.id, count.index)
  max_pods = 50
}

resource "kubernetes_deployment" "tf-aks-p41-deploy" {
  metadata {
    name = "p41-challenge-server"
    labels = {
      name = "p41-challenge-server-deploy"
      app = "p41-sts-server"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        name = "p41-challenge-server-pod"
        app = "p41-sts-server"
      }
    }
    template {
      metadata {
        name = "p41-challenge-server-pod"
        labels = {
          name = "p41-challenge-server-pod"
          app = "p41-sts-server"
      }
     }
      spec {
        container {
          name = "p41-challenge-server"
          image = "cgshash2025/p41testimage"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "tf-aks-p41-lb" {
  metadata {
    name = "p41-challenge-server-service"
    // app = "p41-sts-server"
  }
  spec {
    type = "LoadBalancer"
    port {
      port = 80
      target_port = 5000
    }
    selector = {
      name = "p41-challenge-server-pod"
      app = "p41-sts-server"
    }
  }
}
