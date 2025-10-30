variable "node_name" {
  description = "The name of the Proxmox node where the network bridge will be created"
  type        = string
}

variable "network_card" {
  description = <<-EOT
    Map of network bridge configurations. Each key represents a unique bridge identifier.
    - name: Bridge interface name (e.g., vmbr0, vmbr1)
    - ip_range: IPv4 CIDR address for the bridge (optional)
    - gateway: IPv4 gateway address (optional)
    - ip_range_6: IPv6 CIDR address for the bridge (optional)
    - gateway_6: IPv6 gateway address (optional)
    - mtu: Maximum transmission unit size (default: 1500)
    - comment: Description comment for the bridge (default: "Managed Network by Terraform")
    - vlan_aware: Enable VLAN awareness on the bridge (optional)
    - ports: List of physical network interface names to add to the bridge
    - autostart: Automatically start the bridge on boot (default: true)
  EOT
  type = map(object({
    name       = string
    ip_range   = optional(string)
    gateway    = optional(string)
    ip_range_6 = optional(string)
    gateway_6  = optional(string)
    mtu        = optional(string, "1500")
    comment    = optional(string, "Managed Network by Terraform")
    vlan_aware = optional(bool)
    ports      = list(string)
    autostart  = optional(bool, true)
  }))
  default = {
  }
}