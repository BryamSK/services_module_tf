# Services_module_tf

module "services_module" {
    source = "github.com/BryamSK/services_module_tf?ref=v0.0.2"
    template = "./templates/ecs/myapp.json.tpl"
    vars_template   ={
        project_name   = var.project_name
        app_image = "nginx:1.13"
        app_port       = 80
        fargate_cpu    = "1024"
        fargate_memory = "2048"
        region         = var.aws_region
        environment    = var.environment
  }
    project_name  = var.project_name
    aws_region = var.aws_region
    environment = var.environment
    security_groups  = [module.network_module.aws_security_group_ecs_tasks]
    subnets          = module.network_module.aws_subnet_ids
    targetGroup_id = module.alb_module.targetGroup_id
    elb_id = module.alb_module.elb_id
    alb_frontend_id = module.alb_module.alb_frontend_id
}