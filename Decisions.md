-  The choice of such variables is due to the ability to specify names for containers and select the environment in which to execute.
- For the terraform version, TCP was chosen as an easy-to-implement solution. 
For the Ansible version, a socket-based solution was chosen. The socket-based solution has advantages in processing speed.
- Using modules that provide idempotency in Ansible.
- /healthz Indicates the application's readiness to process incoming requests and traffic. One use case is if the application is behind a load balancer. If the check is passed, it is added to the pool to handle incoming requests.
- With Terraform case, create ready-made Docker images using multi-builds and upload them to the registry. To run, grab the ready-made images from the registry and run them. Set up monitoring and scalability to handle more incoming requests.