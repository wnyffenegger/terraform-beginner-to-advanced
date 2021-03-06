# Can only have one required provider
# terraform {
#   required_providers {
#     github = {
#       source = "integrations/github"
#       version = "4.5.1"
#     }
#   }
# }

provider "github" {
  # Configuration options
  token = "131f55ce52cfd92d67b2e8c5ead8988add9873d0"
}

resource "github_repository" "terraform-course-example" {
  name        = "terraform-course-example"
  visibility  = "private"
}