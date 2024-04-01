variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
  default     = "resoursouthuk89"
}

variable "location" {
  description = "Emplacement du réseau"
  type        = string
  default     = "Uk South"
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
