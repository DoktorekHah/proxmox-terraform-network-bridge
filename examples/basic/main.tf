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
      comment  = "Test bridge created by Terratest"
    }
  }
}

output "network_interface" {
  value = module.network_bridge.network_interface["bridge1"]
}

