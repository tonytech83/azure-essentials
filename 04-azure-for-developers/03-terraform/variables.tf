variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "sql_server_name" {
  type        = string
  description = "The name of the SQL server"
}

variable "sql_admin_user" {
  type        = string
  description = "The name of the SQL admin user"
}

variable "sql_admin_password" {
  type        = string
  description = "The name of the SQL admin password"
}

variable "sql_server_allow_azure_services" {
  type        = bool
  description = "Allow Azure services to access the SQL server"
}

variable "sql_server_allow_remote_host_ip" {
  type        = bool
  description = "Allow remote host IP to access the SQL server"
}

variable "remote_host_ip" {
  type        = string
  description = "The IP address of the remote host"
}

variable "sql_database_name" {
  type        = string
  description = "The name of the SQL database"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "container_registry" {
  type        = string
  description = "The name of Container registry"
}

variable "container_group" {
  type        = string
  description = "The name of Container group"
}

variable "container_name" {
  type        = string
  description = "The name of container"
}

variable "container_image" {
  type        = string
  description = "The container image"
}

variable "dns_name_label" {
  type        = string
  description = "The DNS name of container"
}