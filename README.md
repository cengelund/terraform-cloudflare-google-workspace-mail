# Cloudflare Google MX Records for domains infrastructure

This module creates MX records to Google mails and email related best practises on Cloudflare. 

The module sets up MX, SPF, DKIM and DMARC records.

The SPF policy includes Google by default and rejects all others (`-all`), additional terms can be specified using the `spf_terms` variable.  
## Usage

```terraform
resource "cloudflare_zone" "example_com" {
  zone = "example.com"
}

module "mail_records" {
  source = "git::https://github.com/cengelund/terraform-cloudflare-google-workspace-mail.git"

  zone_id        = cloudflare_zone.example_com.id
  dmarc_rua      = ["dmarc_rua@example.com"]
  dmarc_ruf      = ["dmarc_ruf@example.com", "dmarc_ruf@example.net"]
  dkim_publickey = "your publick key" 
  sub_domain     = "@" #optional default= "@" 
  ttl            = 3600 #optional default = "Auto"
  

}
´´´