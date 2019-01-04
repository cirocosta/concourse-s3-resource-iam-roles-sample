variable "bucket" {
  description = "Name of the bucket to use to back the s3-resource"
  default     = "sample-concourse-s3-resource"
}

variable "region" {
  description = "Region to create the AWS resources"
  default     = "us-east-1"
}

variable "profile" {
  description = "Profile to use when provisioning AWS resources"
  default     = "default"
}
