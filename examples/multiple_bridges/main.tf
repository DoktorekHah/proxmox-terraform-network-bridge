module "network_bridge" {
  source = "../../"

  node_name = var.node_name

  network_card = {
    bridge1 = {
      name     = "vmbr10"
      ip_range = "192.168.10.1/24"
      gateway  = "192.168.10.1"
      mtu      = "1500"
      ports    = ["eth1"]
      comment  = "First test bridge"
    }
    bridge2 = {
      name     = "vmbr11"
      ip_range = "192.168.11.1/24"
      gateway  = "192.168.11.1"
      mtu      = "1500"
      ports    = ["eth2"]
      comment  = "Second test bridge"
    }
    bridge3 = {
      name     = "vmbr12"
      ip_range = "192.168.12.1/24"
      gateway  = "192.168.12.1"
      mtu      = "9000"
      ports    = ["eth3"]
      comment  = "Third test bridge with jumbo frames"
    }
  }
}

output "network_interface" {
  value = module.network_bridge.network_interface
}

