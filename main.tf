# Définition du fournisseur Azure
provider "azurerm" {
  features {}
}

# Définition des variables
variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Emplacement du réseau"
  type        = string
  default     = "southuk"
}

variable "hub_subnet_cidr" {
  description = "CIDR pour le sous-réseau du hub"
  type        = string
  default     = "10.0.0.0/24"
}

variable "spoke_subnet_cidr" {
  description = "CIDR pour les sous-réseaux des spokes"
  type        = string
  default     = "10.1.0.0/24"
}

# Création du groupe de ressources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Création du réseau virtuel pour le hub
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  address_space       = ["${var.hub_subnet_cidr}"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Création du sous-réseau pour le hub
resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["${var.hub_subnet_cidr}"]
}

# Création du réseau virtuel pour le spoke
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "spoke-vnet"
  address_space       = ["${var.spoke_subnet_cidr}"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Création du sous-réseau pour le spoke
resource "azurerm_subnet" "spoke_subnet" {
  name                 = "spoke-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["${var.spoke_subnet_cidr}"]
}

# Configuration des règles de sécurité (à compléter selon les besoins)
# Par exemple, ici, nous autorisons tout le trafic au sein du réseau virtuel

resource "azurerm_network_security_group" "hub_nsg" {
  name                = "hub-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associer le groupe de sécurité au sous-réseau du hub
resource "azurerm_subnet_network_security_group_association" "hub_nsg_association" {
  subnet_id                 = azurerm_subnet.hub_subnet.id
  network_security_group_id = azurerm_network_security_group.hub_nsg.id
}
