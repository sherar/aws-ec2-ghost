data "template_file" "ghost_setup" {
  template = "${file("${path.module}/templates/setup.tpl")}"
  vars = {
    db_name     = var.db_name
    db_password = var.db_password
    ansible_ghost = file("${path.module}/templates/ansible/ghost.yml")
  }
}