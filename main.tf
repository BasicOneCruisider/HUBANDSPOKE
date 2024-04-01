# Définir le fournisseur Azure
provider "azurerm" {
  version = "~> 3.70.0"
}

# Définir les variables
variable "location" {
  type = string
  default = "southuk"
}

# Créer le réseau virtuel hub
resource "azurerm_virtual_network" "hub" {
  name = "hub-vnet"
  location = var.location
  address_space = ["10.0.0.0/16"]

  subnet {
    name = "hub-subnet"
    address_prefix = "10.0.1.0/24"
  }
}

# Créer le réseau virtuel spoke 1
resource "azurerm_virtual_network" "spoke_1" {
  name = "spoke-1-vnet"
  location = var.location
  address_space = ["10.1.0.0/16"]

  subnet {
    name = "spoke-1-subnet"
    address_prefix = "10.1.1.0/24"
  }
}

# Créer le réseau virtuel spoke 2
resource "azurerm_virtual_network" "spoke_2" {
  name = "spoke-2-vnet"
  location = var.location
  address_space = ["10.2.0.0/16"]

  subnet {
    name = "spoke-2-subnet"
    address_prefix = "10.2.1.0/24"
  }
}

# Créer le peering de réseau virtuel entre le hub et spoke 1
resource "azurerm_virtual_network_peering" "hub_spoke_1" {
  name = "hub-spoke-1-peering"
  virtual_network_name = azurerm_virtual_network.hub.name
  remote_virtual_network_name = azurerm_virtual_network.spoke_1.name
  allow_virtual_network_access = true
}

# Créer le peering de réseau virtuel entre le hub et spoke 2
resource "azurerm_virtual_network_peering" "hub_spoke_2" {
  name = "hub-spoke-2-peering"
  virtual_network_name = azurerm_virtual_network.hub.name
  remote_virtual_network_name = azurerm_virtual_network.spoke_2.name
  allow_virtual_network_access = true
}

# Afficher les adresses IP des subnets
output "hub_subnet_ip" {
  value = azurerm_subnet.hub.address_prefix
}

output "spoke_1_subnet_ip" {
  value = azurerm_subnet.spoke_1.address_prefix
}

output "spoke_2_subnet_ip" {
  value = azurerm_subnet.spoke_2.address_prefix
}
