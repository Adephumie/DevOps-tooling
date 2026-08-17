output "webserver_public_IP" {
  value = module.myproject-webserver.webserver_instance.public_ip
}