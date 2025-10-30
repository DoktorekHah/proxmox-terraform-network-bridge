output "network_interface" {
  value = { for k, v in proxmox_virtual_environment_network_linux_bridge.this : k => ({
    id    = v.id,
    name  = v.name
    ports = v.ports
    })
  }
  description = "Network bridge id, name, address and ports"
}
