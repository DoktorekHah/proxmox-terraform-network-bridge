resource "proxmox_virtual_environment_network_linux_bridge" "this" {
  for_each = var.network_card
  provider = proxmox

  node_name = var.node_name
  name      = each.value.name

  address    = each.value.ip_range
  gateway    = each.value.gateway
  address6   = each.value.ip_range_6
  gateway6   = each.value.gateway_6
  mtu        = each.value.mtu
  vlan_aware = each.value.vlan_aware
  ports      = each.value.ports
  autostart  = each.value.autostart

  comment = each.value.comment
}