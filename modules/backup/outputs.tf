output "backup_bucket_arn" {
  value       = opentelekomcloud_s3_bucket.backup.arn
  description = "The ARN of the created bucket"
}

output "backup_bucket_id" {
  value       = opentelekomcloud_s3_bucket.backup.id
  description = "The ID of the created bucket"
}
