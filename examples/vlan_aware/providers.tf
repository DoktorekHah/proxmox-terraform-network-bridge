terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.63.3"
    }
  }
}

provider "proxmox" {
  # Provider configuration should be set via environment variables:
  # PROXMOX_VE_ENDPOINT
  # PROXMOX_VE_USERNAME
  # PROXMOX_VE_PASSWORD
  # PROXMOX_VE_INSECURE (optional)
}

