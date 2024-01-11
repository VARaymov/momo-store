variable "token" {
  description = "Yandex token"
}

variable "cloud_id" {
  description = "Yandex cloud id"
}

variable "folder_id" {
  description = "Yandex folder id"
}

# Провайдер
provider "yandex" {
  token       = var.token
  cloud_id    = var.cloud_id
  folder_id   = var.folder_id
  zone        = "ru-central1-a"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
}

# Локальные переменный
locals {
  cloud_id = var.cloud_id
  folder_id = var.folder_id
}

# Резервирование статического IP адресса для приложения
resource "yandex_vpc_address" "momo-store-address" {
  name = "momo-store-address"
  deletion_protection = "false"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# Резервирование статического IP адресса 
resource "yandex_vpc_address" "argo-cd-address" {
  name = "argo-cd-address"
  deletion_protection = "false"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}


output "momo-store-address" {
  sensitive = false
  value = yandex_vpc_address.momo-store-address.external_ipv4_address[*].address
}

output "argo-cd-address" {
  sensitive = false
  value = yandex_vpc_address.argo-cd-address.external_ipv4_address[*].address
}

