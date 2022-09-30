variable "resource_group_location" {
  default       = "eastus2"
  description   = "Location of the resource group."
}


variable "tags" {
  type = map

  default = {
    OwnerName = "sergiomar",
    PoCName = "Logging and monitoring in Azure"
  }
}
