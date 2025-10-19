terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "docker" {}

# Create a network
resource "docker_network" "app_net" {
  name = "${var.project_name}_app_net"
}

# Create a shared volume
resource "docker_volume" "app_vol" {
  name = "${var.project_name}_app_vol"
}

# Cretate a volume for nginx config
resource "docker_volume" "nginx_config" {
  name = "${var.project_name}_nginx_config"
}

# Create an Nginx container
resource "docker_container" "nginx" {
  image = "nginx:1.29.2"
  name  = "${var.project_name}_nginx"
  networks_advanced {
    name = docker_network.app_net.name
  }
  ports {
    internal = 80
    external = var.host_port
  }

  volumes {
    volume_name    = docker_volume.nginx_config.name
    container_path = "/etc/nginx/conf.d"
  }

  volumes {
    volume_name    = docker_volume.app_vol.name
    container_path = "/var/www/html"
  }

  restart    = "unless-stopped"
  depends_on = [docker_container.php_fpm]

}

# Define the PHP-FPM container
resource "docker_container" "php_fpm" {
  name  = "${var.project_name}_php_fpm"
  image = "php:8.2-fpm-alpine"
  networks_advanced {
    name = docker_network.app_net.name
  }

  volumes {
    volume_name    = docker_volume.app_vol.name
    container_path = "/var/www/html"
  }
}

# Create a test index.php file
resource "local_file" "index_php" {
  content  = <<-EOF
    <?php
    phpinfo();
    ?>
  EOF
  filename = "${path.module}/index.php"
}

# Create nginx.conf from template
resource "local_file" "nginx_conf" {
  filename = "${path.module}/nginx.conf"
  content = templatefile("${path.module}/nginx.conf.tpl", {
    app_env      = var.app_env
    project_name = var.project_name
  })
}

# Coping nginx.conf into the volume using a null resource
resource "null_resource" "copy_nginx_config" {
  provisioner "local-exec" {
    command = "docker cp ${local_file.nginx_conf.filename} ${var.project_name}_nginx:/etc/nginx/conf.d/default.conf && docker restart ${var.project_name}_nginx"
  }

  depends_on = [docker_container.nginx]
}

# Coping index.php into the shared volume using a null resource
resource "null_resource" "copy_index" {
  provisioner "local-exec" {
    command = "docker cp ${local_file.index_php.filename} ${var.project_name}_nginx:/var/www/html/index.php"
  }

  depends_on = [docker_container.nginx]
}
