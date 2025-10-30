# Comprehensive Example

This example demonstrates all features of the Proxmox Network Bridge module:

## Features Demonstrated

1. **Basic Bridge** (`management`)
   - Standard IPv4 configuration
   - Default MTU (1500)
   - Single port attachment

2. **Dual-Stack Bridge** (`dual_stack`)
   - Both IPv4 and IPv6 addressing
   - IPv6 gateway configuration
   - Useful for modern networks

3. **VLAN-Aware Bridge** (`vlan_trunk`)
   - VLAN tagging support
   - Can be used as trunk port
   - Supports tagged traffic

4. **Jumbo Frames Bridge** (`storage`)
   - MTU 9000 for better performance
   - Ideal for storage networks
   - Reduces CPU overhead

## Usage

```bash
# Set your Proxmox credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"

# Initialize and apply
terraform init
terraform plan
terraform apply

# View outputs
terraform output
```

## Prerequisites

Before applying this configuration:

1. Ensure the physical interfaces exist:
   - `eth1` for management
   - `eth2` for dual-stack
   - `eth3` for VLAN trunk
   - `eth4` for storage

2. Verify IP ranges don't conflict with existing networks

3. Check that MTU 9000 is supported for jumbo frames (storage network)

## Customization

Modify the `network_card` map in `main.tf` to match your environment:

- Change interface names (`eth1`, `eth2`, etc.)
- Adjust IP address ranges
- Modify MTU values
- Update bridge names (`vmbr10`, `vmbr11`, etc.)

## Clean Up

```bash
terraform destroy
```

This will remove all created network bridges.

