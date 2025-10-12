// Resource group
resource_group_name = "hw-m4-rg"

// Location
location = "northeurope"

// SQL Server
sql_server_name                 = "hw-m4-sql-srv"
sql_admin_user                  = "sqladminuser"
sql_admin_password              = "New_123123"
sql_server_allow_azure_services = true
sql_server_allow_remote_host_ip = true
sql_database_name               = "hw-m4-db"

// Remote host IP
remote_host_ip = "46.10.209.232"

// Container registry
container_registry = "hwm4cr"

// Container group
container_group = "hw-m4-container"

// Container
container_name      = "webapp"
dns_name_label      = "hw-m4-webapp"
container_image     = "hwm4cr.azurecr.io/hw-m4-image:v1"
