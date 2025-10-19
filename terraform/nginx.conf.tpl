server {
    listen       80;
    server_name  localhost;

    root   /var/www/html;
    index  index.php index.html index.htm;

    location /healthz {
      default_type application/json;
      return 200 '{"status":"ok","service":"nginx","env":"${app_env}"}';
    }

    location / {
      try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      fastcgi_pass ${project_name}_php_fpm:9000;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
      include fastcgi_params;
    }
}
