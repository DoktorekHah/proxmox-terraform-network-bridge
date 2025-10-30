package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestProxmoxNetworkBridgeBasic tests basic network bridge creation
func TestProxmoxNetworkBridgeBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	networkInterface := terraform.OutputMap(t, terraformOptions, "network_interface")

	// Assert that the output map is not empty
	assert.NotEmpty(t, networkInterface, "Network interface output should not be empty")

	// Check that expected keys exist in the output
	assert.Contains(t, networkInterface, "id", "Network interface should contain 'id' key")
	assert.Contains(t, networkInterface, "name", "Network interface should contain 'name' key")
	assert.Contains(t, networkInterface, "ports", "Network interface should contain 'ports' key")
}

// TestProxmoxNetworkBridgeMultiple tests multiple network bridge creation
func TestProxmoxNetworkBridgeMultiple(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/multiple_bridges",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	output := terraform.OutputJson(t, terraformOptions, "network_interface")

	// Assert that the output is not empty
	assert.NotEmpty(t, output, "Network interface output should not be empty")
}

// TestProxmoxNetworkBridgeWithIPv6 tests network bridge with IPv6 configuration
func TestProxmoxNetworkBridgeWithIPv6(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/ipv6",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	networkInterface := terraform.OutputMap(t, terraformOptions, "network_interface")

	// Assert that the output map is not empty
	assert.NotEmpty(t, networkInterface, "Network interface output should not be empty")
}

// TestProxmoxNetworkBridgeWithVLAN tests network bridge with VLAN awareness
func TestProxmoxNetworkBridgeWithVLAN(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/vlan_aware",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	networkInterface := terraform.OutputMap(t, terraformOptions, "network_interface")

	// Assert that the output map is not empty
	assert.NotEmpty(t, networkInterface, "Network interface output should not be empty")
}

// TestProxmoxNetworkBridgePlanOnly tests that terraform plan runs without errors
func TestProxmoxNetworkBridgePlanOnly(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
		PlanFilePath: "./plan",
	}

	// Run "terraform init" and "terraform plan"
	terraform.Init(t, terraformOptions)

	// This will save the plan to the PlanFilePath
	exitCode := terraform.Plan(t, terraformOptions)

	// Assert that the plan was successful (exit code 0 or 2)
	// Exit code 2 means there are changes to apply (expected)
	assert.Contains(t, []int{0, 2}, exitCode, "Terraform plan should complete successfully")
}

// TestProxmoxNetworkBridgeValidation tests input validation
func TestProxmoxNetworkBridgeValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	}

	// Run "terraform init" to install providers
	terraform.Init(t, terraformOptions)

	// Run "terraform validate" to check configuration syntax
	terraform.Validate(t, terraformOptions)
}
