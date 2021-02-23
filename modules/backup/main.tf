#
# backup/main.tf - create an independent disk
#

resource "opentelekomcloud_s3_bucket" "backup" {
  bucket = "rfnl-minetest-backup"
  acl    = "private"

  tags = {
    Name        = "Minetest Backup"
    Environment = "dev"
  }
}

