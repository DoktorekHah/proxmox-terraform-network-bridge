# Proxmox Network Bridge Terraform Module

A comprehensive Terraform/OpenTofu module for managing Proxmox network bridges with integrated security scanning (Checkov) and code linting (TFLint). This module supports both Terraform and OpenTofu through a unified Makefile.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-623CE4)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.0-FFDA18)](https://opentofu.org/)

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Examples](#-examples)
- [Makefile Commands](#-makefile-commands)
- [Security & Linting](#-security--linting)
- [Testing](#-testing)
- [Module Reference](#-module-reference)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Core Capabilities
- **Dual Tool Support**: Works with both Terraform and OpenTofu
- **Bridge Management**: Complete network bridge lifecycle management on Proxmox VE
- **IPv4/IPv6 Support**: Dual-stack networking with IPv4 and IPv6 configuration
- **VLAN Awareness**: Support for VLAN-aware bridges and tagged traffic
- **Multiple Bridges**: Manage multiple network bridges simultaneously

### Security & Quality
- **Security Scanning**: Integrated Checkov for IaC security analysis
- **Code Linting**: TFLint for Terraform/OpenTofu code quality
- **CI/CD Ready**: Pre-configured pipelines for both Terraform and OpenTofu
- **Best Practices**: Follows Terraform/OpenTofu module best practices

### Advanced Features
- **Dual-Stack Networking**: IPv4 and IPv6 address configuration
- **VLAN Tagging**: VLAN-aware bridges for network segmentation
- **Jumbo Frames**: MTU configuration up to 9000 for high-performance networks
- **Port Bonding**: Multiple physical interface attachment
- **Gateway Configuration**: IPv4 and IPv6 gateway management
- **Auto-start**: Configure bridges to start automatically on boot
- **Flexible Port Assignment**: Dynamic port binding to physical interfaces

## 🔧 Prerequisites

### Required Tools
- **Terraform** >= 1.6.0 OR **OpenTofu** >= 1.0
- **Python** >= 3.8 (for Checkov security scanning)
- **TFLint** (automatically installed via Makefile)
- **Proxmox VE** cluster with API access

### Optional Tools
- **Go** >= 1.19 (for Terratest integration tests)
- **pipx** or **pip3** (for Checkov installation)

### Provider Requirements
- `bpg/proxmox` >= 0.63.3

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install all dependencies (Checkov + TFLint)
make install

# Or install individually
make checkov-install
make tflint-install
```

### 2. Initialize TFLint

```bash
# Initialize TFLint plugins (required once)
make tflint-init
```

### 3. Choose Your Tool

#### Using Terraform:
```bash
# Initialize Terraform
make terraform-init

# Validate configuration
make terraform-validate

# Preview changes
make terraform-plan

# Apply changes
make terraform-apply
```

#### Using OpenTofu:
```bash
# Initialize OpenTofu
make tofu-init

# Validate configuration
make tofu-validate

# Preview changes
make tofu-plan

# Apply changes
make tofu-apply
```

### 4. Run Security & Quality Checks

```bash
# Run all checks
make test-all

# Or run individually
make checkov-scan    # Security scan
make tflint-check    # Code linting
```

## 💻 Usage

### Basic Bridge Configuration

```hcl
module "network_bridge" {
  source = "github.com/your-org/proxmox-terraform-network-bridge"

  node_name = "pve01"

  network_card = {
    management = {
      name     = "vmbr10"
      ip_range = "192.168.10.1/24"
      gateway  = "192.168.10.1"
      mtu      = "1500"
      ports    = ["eth1"]
      comment  = "Management network bridge"
    }
  }
}
```

### Dual-Stack IPv4/IPv6 Bridge

```hcl
module "network_bridge_ipv6" {
  source = "github.com/your-org/proxmox-terraform-network-bridge"

  node_name = "pve01"

  network_card = {
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
  }
}
```

### VLAN-Aware Bridge

```hcl
module "network_bridge_vlan" {
  source = "github.com/your-org/proxmox-terraform-network-bridge"

  node_name = "pve01"

  network_card = {
    vlan_trunk = {
      name       = "vmbr12"
      ip_range   = "192.168.12.1/24"
      gateway    = "192.168.12.1"
      mtu        = "1500"
      vlan_aware = true
      ports      = ["eth3"]
      comment    = "VLAN trunk for tagged traffic"
    }
  }
}
```

### Multiple Bridges Configuration

```hcl
module "network_bridges" {
  source = "github.com/your-org/proxmox-terraform-network-bridge"

  node_name = "pve01"

  network_card = {
    management = {
      name     = "vmbr10"
      ip_range = "192.168.10.1/24"
      gateway  = "192.168.10.1"
      mtu      = "1500"
      ports    = ["eth1"]
      comment  = "Management network"
    }

    storage = {
      name     = "vmbr11"
      ip_range = "192.168.11.1/24"
      gateway  = "192.168.11.1"
      mtu      = "9000"
      ports    = ["eth2"]
      comment  = "Storage network with jumbo frames"
    }

    vm_network = {
      name       = "vmbr12"
      ip_range   = "192.168.12.1/24"
      gateway    = "192.168.12.1"
      mtu        = "1500"
      vlan_aware = true
      ports      = ["eth3"]
      comment    = "VM network with VLAN support"
    }
  }
}
```

### Advanced Configuration with All Features

```hcl
module "network_bridge_advanced" {
  source = "github.com/your-org/proxmox-terraform-network-bridge"

  node_name = "pve01"

  network_card = {
    # Basic management network
    management = {
      name      = "vmbr10"
      ip_range  = "192.168.10.1/24"
      gateway   = "192.168.10.1"
      mtu       = "1500"
      ports     = ["eth1"]
      autostart = true
      comment   = "Management network"
    }
    
    # Dual-stack network with IPv6
    dual_stack = {
      name       = "vmbr11"
      ip_range   = "192.168.11.1/24"
      gateway    = "192.168.11.1"
      ip_range_6 = "fd00:dead:beef::/64"
      gateway_6  = "fd00:dead:beef::1"
      mtu        = "1500"
      ports      = ["eth2"]
      autostart  = true
      comment    = "Dual-stack network"
    }
    
    # VLAN-aware trunk bridge
    vlan_trunk = {
      name       = "vmbr12"
      ip_range   = "192.168.12.1/24"
      gateway    = "192.168.12.1"
      mtu        = "1500"
      vlan_aware = true
      ports      = ["eth3"]
      autostart  = true
      comment    = "VLAN trunk for tagged traffic"
    }
    
    # High-performance storage network with jumbo frames
    storage = {
      name      = "vmbr13"
      ip_range  = "192.168.13.1/24"
      gateway   = "192.168.13.1"
      mtu       = "9000"
      ports     = ["eth4"]
      autostart = true
      comment   = "Storage network with jumbo frames"
    }
  }
}

# Output specific bridge details
output "management_bridge" {
  value       = module.network_bridge_advanced.network_interface["management"]
  description = "Management bridge details"
}

output "storage_bridge" {
  value       = module.network_bridge_advanced.network_interface["storage"]
  description = "Storage bridge details"
}
```

## 📂 Examples

The module includes several comprehensive examples:

### Available Examples

- **[basic/](examples/basic/)** - Single network bridge with IPv4
- **[multiple_bridges/](examples/multiple_bridges/)** - Multiple bridges with different configurations
- **[ipv6/](examples/ipv6/)** - Dual-stack IPv4/IPv6 configuration
- **[vlan_aware/](examples/vlan_aware/)** - VLAN-aware bridge setup
- **[comprehensive/](examples/comprehensive/)** - All features combined

### Running Examples

```bash
# Navigate to an example
cd examples/basic

# Set Proxmox credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"
export TF_VAR_node_name="pve01"

# Run Terraform
terraform init
terraform plan
terraform apply

# Clean up
terraform destroy
```

## 📋 Makefile Commands

### Installation & Setup

```bash
make install              # Install all dependencies (Checkov + TFLint)
make checkov-install      # Install Checkov security scanner
make tflint-install       # Install TFLint linter
make tflint-init          # Initialize TFLint plugins
make dev-setup            # Set up complete development environment
```

### Security Scanning (Checkov)

```bash
make checkov-scan         # Run Checkov security scan
make checkov-scan-json    # Run scan with JSON output
make checkov-scan-sarif   # Run scan with SARIF output (CI/CD)
make test-security        # Run security tests only
```

### Code Linting (TFLint)

```bash
make tflint-init          # Initialize TFLint plugins
make tflint-check         # Run TFLint code quality checks
make test-lint            # Run linting tests only
```

### Terraform Commands

```bash
make terraform-init       # Initialize Terraform
make terraform-validate   # Validate Terraform configuration
make terraform-plan       # Create execution plan
make terraform-plan-out   # Create and save execution plan
make terraform-apply      # Apply configuration
make terraform-apply-plan # Apply saved plan
make terraform-destroy    # Destroy infrastructure
make terraform-format     # Format Terraform files
```

### OpenTofu Commands

```bash
make tofu-init            # Initialize OpenTofu
make tofu-validate        # Validate OpenTofu configuration
make tofu-plan            # Create execution plan
make tofu-plan-out        # Create and save execution plan
make tofu-apply           # Apply configuration
make tofu-apply-plan      # Apply saved plan
make tofu-destroy         # Destroy infrastructure
make tofu-format          # Format OpenTofu files
```

### Testing Commands

```bash
make test                 # Run complete test workflow (validate + lint + plan)
make test-all             # Run all tests (security + linting + workflow)
make test-lint            # Run linting tests only
make test-security        # Run security tests only
make test-go              # Run Go-based Terratest integration tests
```

### CI/CD Commands

```bash
make ci                   # Run CI pipeline (security + lint + terraform workflow)
```

### Utility Commands

```bash
make clean                # Clean up generated files
make clean-all            # Clean up all files including state
make help                 # Show all available commands
make docs                 # Display module documentation
```

## 🔒 Security & Linting

### Checkov Security Scanning

This module includes integrated security scanning using [Checkov](https://www.checkov.io/) to ensure your infrastructure code follows security best practices.

**Key Features:**
- 🛡️ Security misconfiguration detection
- ✅ Compliance framework validation
- 📊 Multiple output formats (CLI, JSON, SARIF)
- 🔌 CI/CD integration ready
- 📝 Custom policy support

**Configuration:** `.checkov.yml`

```yaml
framework:
  - terraform

output:
  - cli
  - json
  - sarif

skip-download: true
```

**Usage:**
```bash
# Run security scan
make checkov-scan

# Generate JSON report
make checkov-scan-json

# Generate SARIF report for CI/CD
make checkov-scan-sarif
```

### TFLint Code Quality

TFLint checks your Terraform/OpenTofu code for errors, deprecated syntax, and best practices.

**Key Features:**
- 🔍 Syntax and logic error detection
- 📏 Best practice enforcement
- 🎯 Provider-specific rule sets
- 🔄 Naming convention validation
- 📚 Module version checking

**Configuration:** `.tflint.hcl`

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_naming_convention" {
  enabled = true
}
```

**Usage:**
```bash
# Initialize TFLint (once)
make tflint-init

# Run code quality checks
make tflint-check
```

### Security Best Practices

1. **Always scan before deploy:**
   ```bash
   make checkov-scan && make tflint-check
   ```

2. **Review scan results:**
   - Address all **Failed** checks
   - Understand **Skipped** checks
   - Document exceptions

3. **Integrate into CI/CD:**
   ```bash
   make ci  # Runs security + linting + validation
   ```

## 🧪 Testing

### Quick Test Workflows

```bash
# Run complete test workflow (recommended)
make test-all

# Test Terraform workflow only
make test

# Test security and linting only
make test-security
make test-lint
```

### Terratest Integration Tests

This module includes comprehensive automated testing using Terratest:

```bash
# Run all integration tests
cd terratest && ./test.sh

# Run specific test cases
cd terratest
./test.sh basic           # Basic bridge test
./test.sh multiple        # Multiple bridges test
./test.sh ipv6            # IPv6 dual-stack test
./test.sh vlan            # VLAN-aware test

# Run with custom settings
./test.sh --parallel 4 --timeout 1h

# Generate coverage report
./test.sh --coverage
```

#### Test Prerequisites

```bash
# Set up Proxmox credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"
export PROXMOX_VE_INSECURE="true"
export TF_VAR_node_name="pve"
```

#### Test Cases

| Test | Description | Example Directory |
|------|-------------|-------------------|
| **Basic** | Single bridge with IPv4 | `examples/basic` |
| **Multiple** | Multiple bridges with different configs | `examples/multiple_bridges` |
| **IPv6** | Dual-stack IPv4/IPv6 configuration | `examples/ipv6` |
| **VLAN** | VLAN-aware bridge setup | `examples/vlan_aware` |
| **Validation** | Configuration syntax validation | `examples/basic` |
| **Plan** | Terraform plan validation | `examples/basic` |

### CI/CD Pipeline

The `ci` target runs a complete pipeline suitable for CI/CD:

```bash
make ci
```

This executes:
1. Checkov security scan
2. TFLint initialization
3. TFLint code quality check
4. Terraform/OpenTofu initialization
5. Configuration validation
6. Execution plan generation

### Manual Testing

```bash
# 1. Initialize
make terraform-init

# 2. Validate syntax
make terraform-validate

# 3. Check code quality
make tflint-check

# 4. Security scan
make checkov-scan

# 5. Preview changes
make terraform-plan

# 6. Apply (with approval)
make terraform-apply
```

## 📚 Module Reference

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement_proxmox) | >= 0.63.3 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider_proxmox) | >= 0.63.3 |

### Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_network_linux_bridge.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_network_linux_bridge) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_name"></a> [node_name](#input_node_name) | The name of the Proxmox node where the network bridge will be created | `string` | n/a | yes |
| <a name="input_network_card"></a> [network_card](#input_network_card) | Map of network bridge configurations. Each key represents a unique bridge identifier.<br/>- **name**: Bridge interface name (e.g., vmbr0, vmbr1)<br/>- **ip_range**: IPv4 CIDR address for the bridge (optional)<br/>- **gateway**: IPv4 gateway address (optional)<br/>- **ip_range_6**: IPv6 CIDR address for the bridge (optional)<br/>- **gateway_6**: IPv6 gateway address (optional)<br/>- **mtu**: Maximum transmission unit size (default: 1500)<br/>- **comment**: Description comment for the bridge (default: "Managed Network by Terraform")<br/>- **vlan_aware**: Enable VLAN awareness on the bridge (optional)<br/>- **ports**: List of physical network interface names to add to the bridge<br/>- **autostart**: Automatically start the bridge on boot (default: true) | <pre>map(object({<br/>    name       = string<br/>    ip_range   = optional(string)<br/>    gateway    = optional(string)<br/>    ip_range_6 = optional(string)<br/>    gateway_6  = optional(string)<br/>    mtu        = optional(string, "1500")<br/>    comment    = optional(string, "Managed Network by Terraform")<br/>    vlan_aware = optional(bool)<br/>    ports      = list(string)<br/>    autostart  = optional(bool, true)<br/>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interface"></a> [network_interface](#output_network_interface) | Network bridge information including id, name, and ports for each configured bridge |

### Example Output Usage

```hcl
# Access all bridges
output "all_bridges" {
  value = module.network_bridge.network_interface
}

# Access specific bridge
output "management_bridge_id" {
  value = module.network_bridge.network_interface["management"].id
}

output "management_bridge_name" {
  value = module.network_bridge.network_interface["management"].name
}

output "management_bridge_ports" {
  value = module.network_bridge.network_interface["management"].ports
}
```
<!-- END_TF_DOCS -->

## 🛠️ Development

### Setting Up Development Environment

```bash
# Complete setup
make dev-setup

# This will:
# - Install Checkov
# - Install TFLint
# - Initialize TFLint plugins
```

### Code Quality

```bash
# Format code
make terraform-format  # or make tofu-format

# Validate configuration
make terraform-validate  # or make tofu-validate

# Run linting
make tflint-check

# Run security scan
make checkov-scan
```

### Development Workflow

1. **Make Changes**
   ```bash
   # Edit your .tf files
   vim main.tf
   ```

2. **Format Code**
   ```bash
   make terraform-format
   ```

3. **Validate & Lint**
   ```bash
   make terraform-validate
   make tflint-check
   ```

4. **Security Scan**
   ```bash
   make checkov-scan
   ```

5. **Test**
   ```bash
   make terraform-plan
   ```

6. **Clean Up**
   ```bash
   make clean
   ```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
make terraform-plan

# Enable OpenTofu debug logging
export TF_LOG=DEBUG
make tofu-plan

# Clean up everything and start fresh
make clean-all
make terraform-init
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Before Contributing

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow Terraform/OpenTofu best practices
   - Update documentation
   - Add tests if applicable

4. **Run quality checks**
   ```bash
   make terraform-format
   make tflint-check
   make checkov-scan
   make test-all
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "feat: add new feature"
   ```

6. **Submit a pull request**

### Development Guidelines

- ✅ Always run `make checkov-scan` before committing
- ✅ Ensure all tests pass with `make test-all`
- ✅ Follow semantic versioning
- ✅ Update README for new features
- ✅ Add examples for new functionality
- ✅ Document any breaking changes

### Code Style

- Use descriptive variable names
- Add comments for complex logic
- Keep functions small and focused
- Follow the existing code structure

## 📖 Additional Resources

### Documentation
- [Proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Proxmox Network Configuration](https://pve.proxmox.com/wiki/Network_Configuration)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/language/modules/develop)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)

### Networking Resources
- [Linux Bridge Documentation](https://wiki.linuxfoundation.org/networking/bridge)
- [VLAN Configuration](https://www.kernel.org/doc/Documentation/networking/vlan.txt)
- [IPv6 Addressing](https://www.rfc-editor.org/rfc/rfc4291.html)
- [Jumbo Frames Guide](https://en.wikipedia.org/wiki/Jumbo_frame)

### Community
- [Proxmox Forum](https://forum.proxmox.com/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core)
- [OpenTofu Community](https://opentofu.org/community/)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/your-org/repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/repo/discussions)
- **Security**: Report security issues privately to security@your-org.com

## 🙏 Acknowledgments

- [BPG Proxmox Provider](https://github.com/bpg/terraform-provider-proxmox) - Excellent Proxmox provider
- [Checkov](https://www.checkov.io/) - Infrastructure security scanning
- [TFLint](https://github.com/terraform-linters/tflint) - Terraform linting

---

**⚠️ Important Notes:**

- Always review security scan results before deploying to production
- Test changes in a development environment first
- Verify physical network interfaces exist before assigning to bridges
- Ensure IP address ranges don't conflict with existing networks
- Check MTU compatibility when using jumbo frames
- Keep your Proxmox API credentials secure
- Regularly update providers and tools to latest versions
- Back up your Terraform/OpenTofu state files

**Network Bridge Best Practices:**

- Use descriptive bridge names (e.g., vmbr0 for management, vmbr1 for storage)
- Reserve low bridge numbers (vmbr0-vmbr9) for infrastructure
- Document IP address schemes and VLAN assignments
- Test network changes in non-production environments first
- Monitor bridge performance and adjust MTU as needed
- Use VLAN awareness only when tagged traffic is required
- Implement proper network segmentation for security

**Made with ❤️ for the Proxmox and Terraform/OpenTofu community**
