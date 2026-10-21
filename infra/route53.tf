terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_route53_zone" "primary" {
  name         = "xl-optim.com."
  private_zone = false
}

# Apex domain A records pointing to GitHub Pages IP addresses
resource "aws_route53_record" "apex_a" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "xl-optim.com"
  type    = "A"
  ttl     = 300
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

# Apex domain AAAA records pointing to GitHub Pages IPv6 addresses
resource "aws_route53_record" "apex_aaaa" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "xl-optim.com"
  type    = "AAAA"
  ttl     = 300
  records = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]
}

# Subdomain CNAME pointing to pedrocamargo.github.io
resource "aws_route53_record" "www_cname" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.xl-optim.com"
  type    = "CNAME"
  ttl     = 300
  records = [
    "pedrocamargo.github.io"
  ]
}
