# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}
variable "public_key_name" {}
variable "public_key_location" {}

# Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "user" {
  name       = var.public_key_name
  public_key = file(var.public_key_location)
}

resource "hcloud_primary_ip" "primary_ip_1" {
  name          = "primary_ip_risaquerol"
  datacenter    = "fsn1-dc14"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_firewall" "firewall-risaquerol-web" {
  name = "firewall-risaquerol-web"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "5432"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "risaquerol" {
  name         = "risaquerol-web"
  image        = "debian-12"
  server_type  = "cx22"
  datacenter   = "fsn1-dc14"
  backups      = true
  ssh_keys     = [hcloud_ssh_key.user.id]
  firewall_ids = [hcloud_firewall.firewall-risaquerol-web.id]
  user_data    = file("./cloud-init.yaml")
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.primary_ip_1.id
  }
}
