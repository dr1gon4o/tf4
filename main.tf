terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
      # version = "4.24.0"
      # version = "4.26.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "taskboardstorage123"
    container_name       = "taskboardcontainer1"
    key                  = "terraform.tfstate"
    subscription_id      = "225ebe37-0c58-432a-a60a-44ffcbc2dcae" # Ensure this is specified
  }
}

provider "azurerm" {
  features {}
  subscription_id = "225ebe37-0c58-432a-a60a-44ffcbc2dcae"
}

resource "random_integer" "ri" {
  min = 1000 # Replace with your minimum range
  max = 9999 # Replace with your maximum range
}

resource "azurerm_resource_group" "arg" {
  # ei taka moje da go napravia ako iskam da ostavia random nomer da se generira sled vsiako variable ime(name)
  # moje i bez donlata cherta predi dolarcheto $
  name = "${var.resource_group_name}${random_integer.ri.result}"
  # name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_service_plan" "aasp" {
  name = var.app_service_plan_name
  # name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  # kind                = "Linux"
  os_type = "Linux"
  # sku {
  #   tier = "Free"
  #   size = "F1"
  # }
  sku_name = "F1"

}

resource "azurerm_mssql_server" "hoho" {
  # name                         = var.sql_server_name
  name                         = "${var.sql_server_name}${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
}

resource "azurerm_mssql_firewall_rule" "example" {
  # name             = var.firewall_rule_name
  name             = "${var.firewall_rule_name}${random_integer.ri.result}"
  server_id        = azurerm_mssql_server.hoho.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "10.0.17.62"
}

resource "azurerm_mssql_database" "amsd" {
  # name         = var.sql_database_name
  name           = "${var.sql_database_name}${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.hoho.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
  # tova e da zaebiklim problema s sql s nashite accounti + zobe redundat false
  storage_account_type = "Zone"
  geo_backup_enabled   = false


}

resource "azurerm_linux_web_app" "haha" {
  # name                = var.app_service_name
  name                = "${var.app_service_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  # app_service_plan_id = azurerm_app_service_plan.aasp.id
  service_plan_id = azurerm_service_plan.aasp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.hoho.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.amsd.name};User ID=${azurerm_mssql_server.hoho.administrator_login};Password=${azurerm_mssql_server.hoho.administrator_login_password};Trusted_Connection=False;MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id   = azurerm_linux_web_app.haha.id
  repo_url = var.github_repo_url
  branch   = "main"
}

