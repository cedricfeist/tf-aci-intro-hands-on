terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "0.7.0"
    }
  }
}

provider "aci" {
  # cisco-aci user name
  username = var.username
  # cisco-aci password
  password = var.password
  # cisco-aci url
  url      = var.apic_url
  insecure = true
}

resource "aci_tenant" "terraform_tenant" {
  name        = var.tenant_name
  description = "Tenant created by TF"
}

resource "aci_vrf" "terraform_vrf" {
  tenant_dn   = aci_tenant.terraform_tenant.id
  description = "VRF created by TF"
  name        = "${var.tenant_name}_terraform_vrf"
}
