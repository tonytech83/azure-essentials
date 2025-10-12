# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "=3.113.0"
    }
    docker  = { 
        source = "kreuzwerker/docker", 
        version = ">=3.0.0" }
    null = {
      source  = "hashicorp/null"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
}

# 3. Create a resource group
resource "azurerm_resource_group" "arg" {
    name     = var.resource_group_name
    location = var.location
}

# 4. Create logical SQL server
resource "azurerm_mssql_server" "sqlsrv" {
    depends_on                    = [ azurerm_resource_group.arg ]
    name                          = var.sql_server_name
    resource_group_name           = var.resource_group_name
    location                      = var.location
    version                       = "12.0"
    administrator_login           = var.sql_admin_user
    administrator_login_password  = var.sql_admin_password
    minimum_tls_version           = "1.2"
    public_network_access_enabled = true
}

# 5. Allow all Azure services to access our SQL server
# (0.0.0.0 mean allow access from all Azure services and resources)
resource "azurerm_mssql_firewall_rule" "sql_srv_firewall_rule_internal" {
    name                = "AllowAzureServices"
    server_id           = azurerm_mssql_server.sqlsrv.id
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "0.0.0.0"
}

# 6. Allow specific public IP to access server
resource "azurerm_mssql_firewall_rule" "sql_srv_firewall_rule_external" {
    name                = "AllowRemoteHostIp"
    server_id           = azurerm_mssql_server.sqlsrv.id
    start_ip_address    = var.remote_host_ip
    end_ip_address      = var.remote_host_ip
}

# 7. Create SQL database
resource "azurerm_mssql_database" "sqldb" {
    name        = var.sql_database_name
    server_id   = azurerm_mssql_server.sqlsrv.id
    depends_on  = [ azurerm_mssql_server.sqlsrv ]
    sku_name     = "S0"
}

# 8. Initialize SQL database with db/seed.sql file
resource "null_resource" "seed_db" {
    depends_on  = [azurerm_mssql_database.sqldb]
    triggers    = {
      seed_hash = filesha256("${path.module}/../db/seed.sql")
      db_name   = azurerm_mssql_database.sqldb.name
    }
    provisioner "local-exec" {
      command   = "tsql -H ${azurerm_mssql_server.sqlsrv.fully_qualified_domain_name} -p 1433 -U ${var.sql_admin_user} -P \"${var.sql_admin_password}\" -D ${azurerm_mssql_database.sqldb.name} < \"${path.module}/../db/seed.sql\""
    }
}

# 9. Create Container registry
resource "azurerm_container_registry" "acr" {
    name                            = var.container_registry
    resource_group_name             = var.resource_group_name
    location                        = var.location
    sku                             = "Standard"
    admin_enabled                   = true
    zone_redundancy_enabled         = false
    public_network_access_enabled   = true
}

# 10. Push image to Container registry
provider "docker" {
  registry_auth {
    address  = azurerm_container_registry.acr.login_server 
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
}

# 11. Push the local image (must already exist locally with this exact tag)
resource "docker_registry_image" "push_hw_m4" {
    name = "hwm4cr.azurecr.io/hw-m4-image:v1"
}

# 12. Create container from our image hwm4cr.azurecr.io/hw-m4-image:v1
resource "azurerm_container_group" "hw_m4_aci" {
    depends_on          = [docker_registry_image.push_hw_m4]
    name                = var.container_group
    resource_group_name = azurerm_resource_group.arg.name
    location            = azurerm_resource_group.arg.location
    os_type             = "Linux"

    ip_address_type     = "Public"
    dns_name_label      = var.dns_name_label 
    restart_policy      = "Always"

    image_registry_credential {
        server          = azurerm_container_registry.acr.login_server
        username        = azurerm_container_registry.acr.admin_username
        password        = azurerm_container_registry.acr.admin_password
    }

    container {
        name            = var.container_name
        image           = var.container_image
        cpu             = 1
        memory          = 1.5
        ports { port = 80 }
    }
}