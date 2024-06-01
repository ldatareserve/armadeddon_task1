terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = var.task_2[0]
  region      = var.task_2[1]
  zone        = var.task_2[2]
  credentials = var.task_2[3]
}

#Variables
variable "task_2" {
  type = list(string)
  description = "Grouping all the variables"
  default =  ["third-wharf-422001","us-central1",
  "us-central1-a","third-wharf-422001-430bd7a56f65.json","US",
  "https://storage.googleapis.com/"] 
}
#Create a bucket
resource "google_storage_bucket" "task_2_order66" {
  name          = "${var.task_2[0]}-task_2_order66"
  location      = var.task_2[4]
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

    uniform_bucket_level_access = false
}
#Make the bucket public
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.task_2_order66.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.task_2_order66.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.task_2_order66.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

resource "google_storage_bucket_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.jpg")
  bucket       = google_storage_bucket.task_2_order66.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "images/jpg"
}
#Output the URL
output "bucket_url" {
  value = "${var.task_2[5]}${google_storage_bucket.task_2_order66.name}/index.html"
}
