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
  token = "fake-token-here"
}

resource "github_repository" "terraform-course-example" {
  name        = "terraform-course-example"
  visibility  = "private"
}