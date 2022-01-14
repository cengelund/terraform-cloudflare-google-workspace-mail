
resource "cloudflare_record" "mx" {
  for_each = {
    main = { server = "aspmx.l.google.com", priority = 1 }
    alt1 = { server = "alt1.aspmx.l.google.com", priority = 5 }
    alt2 = { server = "alt2.aspmx.l.google.com", priority = 5 }
    alt3 = { server = "alt3.aspmx.l.google.com", priority = 10 }
    alt4 = { server = "alt4.aspmx.l.google.com", priority = 10 }
  }

  zone_id  = var.zone_id
  name     = var.sub_domain
  type     = "MX"
  value    = each.value.server
  ttl      = var.ttl
  priority = each.value.priority
}

resource "cloudflare_record" "spf" {
  zone_id = var.zone_id
  name    = "@"
  value   = "v=spf1 ${join(" ", concat(["include:_spf.google.com"], var.spf_terms, ["-all"]))}"
  type    = "TXT"
  ttl     = var.ttl
}

resource "cloudflare_record" "dkim" {
  zone_id = var.zone_id
  name    = format("%s._domainkey", var.domainkey_prefix)
  value   = "v=DKIM1; p="
  type    = "TXT"
  ttl     = var.ttl
}

resource "cloudflare_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc"
  value   = "v=DMARC1; p=reject; rua=mailto:${join(",mailto:", var.dmarc_rua)}; ruf=mailto:${join(",mailto:", var.dmarc_ruf)}; fo=1:d:s"
  type    = "TXT"
  ttl     = var.ttl
}
