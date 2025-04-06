# •	Resource group name
# •	Resource group location
# •	App service plan name
# •	App service name
# •	SQL server name
# •	SQL database name
# •	SQL administrator login username
# •	SQL administrator password
# •	Firewall rule name
# •	GitHub repo URL

variable "resource_group_name" {
  description = "resource group name in azure"
  type        = string
  default     = "taskboardrg"
}

variable "resource_group_location" {
  description = "resource group location in azure"
  type        = string
  default     = "North Europe"
}

variable "app_service_plan_name" {
  description = "app service plan name in azure"
  type        = string
  default     = "task-board-plan"
}

variable "app_service_name" {
  description = "app service name in azure"
  type        = string
  default     = "task-board"
}

variable "sql_server_name" {
  description = "sql server name in azure"
  type        = string
  default     = "taskboard-sql"
}

variable "sql_database_name" {
  description = "sql database name in azure"
  type        = string
  default     = "amsd-db"
}

variable "sql_admin_login_username" {
  description = "sql administrator login username in azure"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "sql administrator password in azure"
  type        = string
  default     = "P@ssw0rd1234!"
}

variable "firewall_rule_name" {
  description = "firewall rule name in azure"
  type        = string
  default     = "FirewallRule1"
}

variable "github_repo_url" {
  description = "github repo url"
  type        = string
  default     = "https://github.com/dr1gon4o/Azure-TaskBoard.git"
}
