terraform {
  cloud {
    organization = "solamarpreet"

    workspaces {
      name = "terraform-on-aws"
    }
  }
}