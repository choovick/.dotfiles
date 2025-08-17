return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "tf", "tfvars" },
  root_markers = { ".terraform", "*.tf", "*.tfvars" },
}