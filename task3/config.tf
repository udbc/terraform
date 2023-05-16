resource "null_resource" "push_db_connection_config" {
  count = var.instance_count

  triggers = {
    config_updates = templatefile("${path.module}/templates/config.init.tpl", { rds = data.aws_db_instance.database, rds_password = var.rds_password })
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/terraform-ap")
    host        = aws_instance.frontend[count.index].public_ip
  }

  provisioner "file" {
    content     = templatefile("${path.module}/templates/config.init.tpl", { rds = data.aws_db_instance.database, rds_password = var.rds_password })
    destination = "/var/www/html/config.ini"
  }
}
resource "null_resource" "apply_db_schema" {
  triggers = {
    rds_ids = data.aws_db_instance.database.db_instance_identifier
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/terraform-ap")
    host        = element(aws_instance.frontend.*.public_ip, 0)
  }

  provisioner "file" {
    content     = templatefile("${path.module}/templates/apply_schema.sh.tpl", { rds = data.aws_db_instance.database, rds_password = var.rds_password })
    destination = "/tmp/apply_schema.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/apply_schema.sh",
      "/tmp/apply_schema.sh || true",
    ]
  }
}
