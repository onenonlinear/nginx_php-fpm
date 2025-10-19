
## Nginx + php-fpm

Status of last event for Terraform workflow: <br>
<img src="https://github.com/onenonlinear/nginx_php-fpm/github-actions/actions/workflows/terraform.yml/badge.svg"><br>

### Terraform 
1. clone repo
2. ```cd terraform``` and run command:
   - terraform fmt --check
   - terraform init
   - terraform validate
   - terraform plan
   - terraform apply -auto-approve
3. check
   - curl http://localhost:8080/
   - curl http://localhost:8080/healthz

