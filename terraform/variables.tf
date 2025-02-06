variable "rg_name" {
  default = "tf-p41test-rg"
}

variable "location" {
  default = "eastus"
}

variable "azure-client-id" {
  type = string
  sensitive = true
}

variable "azure-client-secret" {
  type = string
  sensitive = true
}

variable "azure-subscription" {
  type = string
  sensitive = true
}

variable "azure-tenant" {
  type = string
  sensitive = true
}

variable "env" {
  default = "tf-dev"
}

variable "vnet-name" {
    default = "tf-test-vnet"
}

variable "vnet-rg-name" {
  default = "tf-test-vnet-rg"
}

variable "aks-np-rg-name" {
  default = "tf-test-aks-np-rg"
}

variable "nsg-name-public" {
  default = "tf-test-public-nsg"
}

variable "nsg-name-private" {
  default = "tf-test-private-nsg"
}

variable "aks-name" {
  default = "tf-test-aks"
}
