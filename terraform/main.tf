module "network" {
  source = "./modules/network"

  name               = "${var.project_name}-${var.environment}"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "compute" {
  source = "./modules/compute"

  name             = "${var.project_name}-${var.environment}"
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.public_subnet_id
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  public_key       = file(pathexpand(var.public_key_path))
  admin_cidr       = var.admin_cidr
  app_cidr         = var.app_cidr
}
