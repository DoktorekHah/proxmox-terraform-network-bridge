module "network_bridge" {
  source = "../../"

  node_name = var.node_name

  network_card = {
    # Basic bridge
    management = {
      name     = "vmbr10"
      ip_range = "192.168.10.1/24"
      gateway  = "192.168.10.1"
      mtu      = "1500"
      ports    = ["eth1"]
      comment  = "Management network"
    }
    
    # Bridge with IPv6
    dual_stack = {
      name       = "vmbr11"
      ip_range   = "192.168.11.1/24"
      gateway    = "192.168.11.1"
      ip_range_6 = "fd00:dead:beef::/64"
      gateway_6  = "fd00:dead:beef::1"
      mtu        = "1500"
      ports      = ["eth2"]
      comment    = "Dual-stack network"
    }
    
    # VLAN-aware bridge
    vlan_trunk = {
      name       = "vmbr12"
      ip_range   = "192.168.12.1/24"
      gateway    = "192.168.12.1"
      mtu        = "1500"
      vlan_aware = true
      ports      = ["eth3"]
      comment    = "VLAN trunk for tagged traffic"
    }
    
    # Jumbo frames bridge for storage
    storage = {
      name     = "vmbr13"
      ip_range = "192.168.13.1/24"
      gateway  = "192.168.13.1"
      mtu      = "9000"
      ports    = ["eth4"]
      comment  = "Storage network with jumbo frames"
    }
  }
}

output "network_interface" {
  value       = module.network_bridge.network_interface
  description = "All created network bridges"
}

output "management_bridge" {
  value       = module.network_bridge.network_interface["management"]
  description = "Management network bridge details"
}

output "storage_bridge" {
  value       = module.network_bridge.network_interface["storage"]
  description = "Storage network bridge details"
}

