
## Nginx + php-fpm

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

