terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
}

provider "yandex" {
  cloud_id  = "b1gkhvl4k4ipvlnpg1gp"
  folder_id = "b1gbcaasm7bnqpfm136f"
  zone      = "ru-central1-a"
}
