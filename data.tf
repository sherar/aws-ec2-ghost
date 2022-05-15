data "template_file" "ghost_setup" {
  template = "${file("${path.module}/templates/ghost.tpl")}"
  vars = {
    db_name     = var.db_name
    db_password = var.db_password
    sql_config  = file("${path.module}/templates/setup.sql")
  }
}