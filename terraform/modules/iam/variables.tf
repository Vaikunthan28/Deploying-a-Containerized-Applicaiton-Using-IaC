# Inputs for the IAM module

variable "tags" {
  description = "Tags to apply to IAM roles"
  type        = map(string)
}