data "google_project" "project" {
}


output "google_project" {
  value = {
    project_id = data.google_project.project.project_id
    name       = data.google_project.project.name
    number     = data.google_project.project.number
  }
}

data "google_access_approval_project_service_account" "service_account" {
  project_id = "meysam-io"
}

output "google_access_approval_project_service_account" {
  value = data.google_access_approval_project_service_account.service_account
}
