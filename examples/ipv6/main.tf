module "network_bridge" {
  source = "../../"

  node_name = var.node_name

  network_card = {
    bridge1 = {
      name       = "vmbr10"
      ip_range   = "192.168.10.1/24"
      gateway    = "192.168.10.1"
      ip_range_6 = "fd00:dead:beef::/64"
      gateway_6  = "fd00:dead:beef::1"
      mtu        = "1500"
      ports      = ["eth1"]
      comment    = "Test bridge with IPv6"
    }
  }
}

output "network_interface" {
  value = module.network_bridge.network_interface["bridge1"]
}

