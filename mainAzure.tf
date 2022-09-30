terraform {
  required_version = ">=1.1"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.94"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "772526ab4921" 
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-np-ea-example-test"
  location = var.resource_group_location

  tags = var.tags
}

#Create storage account
resource "azurerm_storage_account" "static_storage" {
  name                     = "sanpeterraformtest"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  static_website {
     index_document = "index.html"
   }
  tags = var.tags
}


#Create application service plan
 resource "azurerm_app_service_plan" "terraform_service_plan" {
   name                = "asp-np-ea-terraform2"
   location            = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name

   sku {
     tier = "Standard"
     size = "S1"
   }
   tags = var.tags
 }

#Create application service
 resource "azurerm_app_service" "app_service_terraform" {
   name                = "apia-np-ea-terraform2"
   location            = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
   app_service_plan_id = azurerm_app_service_plan.terraform_service_plan.id
   logs{
      detailed_error_messages_enabled = true
   }

 
  auth_settings {
       enabled          = true
    }

   identity {
     type = "SystemAssigned"
   }

   site_config {
     http2_enabled = true
     dotnet_framework_version = "v4.0"
     scm_type                 = "LocalGit"
   }

   app_settings = {
     "CORECLR_ENABLE_PROFILING" = "1"
     "CORECLR_PROFILER" = "{846F5F1C-F9AE-4B07-969E-05C26BC060D8}"
     "CORECLR_PROFILER_PATH" = "apia-np-ea-terraform\\datadog\\win-x64\\Datadog.Trace.ClrProfiler.Native.dll"
     "DD_API_KEY" = "007eeec9b16"
     "DD_DOTNET_TRACER_HOME" = "apia-np-ea-terraform/datadog"
     "DD_LOGS_INJECTION" = "true"
     "DD_SITE" = "us3.datadoghq.com"     
   }

   connection_string {
     name  = "Database"
     type  = "SQLServer"
     value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
   }
   tags = var.tags
 }


resource "azurerm_sql_database" "name" {
  name = afasf
  location = asdfasf
  server_name = asdfasfasfasf
  resource_group_name = azurerm_resource_group.rg.name
  
  
}
