# Services_module_tf
Modulo para servicio ECS Fargate-Docker

## Ultima Version estable
v0.0.1

```
module "services_module" {
    #source = "./../services_module_tf"
    source = "github.com/BryamSK/services_module_tf?ref=v0.0.1"
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
```
## Depende de los modulos
### network_module_tf
Disponible en: github.com/BryamSK/network_module_tf
### alb_module_tf
Disponible en: github.com/BryamSK/services_module_tf

## Variablesde entrada
```
variable "project_name" {
  description = "The name to use for tags"
  type        = string
}
variable "aws_region" {
  description = "The name to use for tags"
  type        = string
}
variable "environment" {
  description = "The name to use for tags"
  type        = string
}
variable "security_groups" {
  description = "The name to use for tags"
}
variable "subnets" {
  description = "The name to use for tags"
}
variable "targetGroup_id" {
  description = "The name to use for tags"
}
variable "template" {
  description = "The name to use for tags"
}
variable "vars_template" {
  description = "The name to use for tags"
}
variable "elb_id" {
  description = "The name to use for tags"
}
variable "alb_frontend_id" {
  description = "The name to use for tags"
}
```