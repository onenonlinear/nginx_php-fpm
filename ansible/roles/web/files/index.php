<?php
header('Content-Type: application/json');
echo json_encode([
    "status" => "ok",
    "service" => "php",
    "env" => getenv('APP_ENV') ?: 'dev'
]);
