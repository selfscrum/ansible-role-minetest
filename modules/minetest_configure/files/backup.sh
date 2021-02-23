#!/bin/bash

echo "$(date  '+%Y-%m-%d %H:%M:%S') $(hostname) Starting Backup"
systemctl stop mapserver.service
systemctl stop minetest.service

# to get the S3 credentials
source /home/minetest/.profile
cd /usr/share
archive="backup-$(date "+%Y-%m-%d").tar"
tar cf $archive minetest
gzip $archive
s3 put rfnl-minetest-backup/$archive.gz filename=$archive.gz > /dev/null
rm $archive.gz
systemctl start minetest.service
systemctl status minetest.service
systemctl start mapserver.service
systemctl status mapserver.service
echo "$(date  '+%Y-%m-%d %H:%M:%S') $(hostname) Backup finished"
