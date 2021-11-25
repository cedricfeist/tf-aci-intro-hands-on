terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "0.7.0"
    }
  }
}

provider "aci" {
  # cisco-aci user name
  username = "${var.username}"
  # cisco-aci password
  password = "${var.password}"
  # cisco-aci url
  url      =  "${var.apic_url}"
  insecure = true
}

resource "aci_tenant" "terraform_tenant" {
  name        = "${var.aci_tenant}"   
  description = "Tenant created by TF"
}

#resource "aci_bridge_domain" "terraform_bridgedomain" {
#  tenant_dn   = "${aci_tenant.terraform_tenant.id}"
#  name        = "cfeist_terraform_bridgedomain"
#  description = "BD created by TF"
#}

resource "aci_vrf" "terraform_vrf" {
  tenant_dn = aci_tenant.terraform_tenant.id
  description = "VRF created by TF"
  name = "cfeist_terraform_vrf"
  
}

resource "aci_application_profile" "guestbook-ap" {
  tenant_dn = aci_tenant.terraform_tenant.id
  description = "AP created by Terraform"
  name = "guestbook-AP"
}

resource "aci_application_epg" "frontend_epg" {
  application_profile_dn = aci_application_profile.guestbook-ap.id
  description = "frontend EPG by Terraform"
  name = "frontend"
}

resource "aci_application_epg" "kubernetes_epg" {
  application_profile_dn = aci_application_profile.guestbook-ap.id
  description = "kubernetes EPG by Terraform"
  name = "kubernetes"
}

resource "aci_application_profile" "kubernetes_ap" {
  tenant_dn = aci_tenant.terraform_tenant.id
  description = "default kubernetes AP by Terraform"
  name = "kubernetes" 
}
