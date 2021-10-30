[
    {
      "name": "${name}",
      "image": "${container_image}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "controller"
        }
      }
    }
]
