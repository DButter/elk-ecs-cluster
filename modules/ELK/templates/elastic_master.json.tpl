[
    {
      "name": "${name}",
      "image": "${container_image}",
      "essential": true,
      "portMappings": [{
  			"hostPort": 9200,
  			"protocol": "tcp",
  			"containerPort": 9200
  		},
      {
  			"hostPort": 9300,
  			"protocol": "tcp",
  			"containerPort": 9300
  		}],
      "healthCheck": {
        "command": [
          "CMD-SHELL","curl -I -f --max-time 5 http://localhost:9200 || exit 1"
        ],
        "interval": 10,
        "startPeriod": 60,
        "retries": 5,
        "timeout": 5
      },
      "environment": [
        {
          "name": "cluster.name",
          "value": "${name}"
        },
        {
          "name": "node.name",
          "value": "${node_name}"
        },
        {
          "name": "cluster.initial_master_nodes",
          "value": "${masters}"
        },
        {
          "name": "discovery.seed_hosts",
          "value": "${discovery_seed_hosts}"
        },
        {
          "name": "node.store.allow_mmap",
          "value": "false"
        }
      ],
      "ulimits": [{
  				"Name": "core",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "cpu",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "data",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "fsize",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "locks",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "memlock",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "msgqueue",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "nice",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "nofile",
  				"softLimit": 1024000,
  				"hardLimit": 1024000
  			},
  			{
  				"Name": "nproc",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "rss",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "rtprio",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "rttime",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "sigpending",
  				"softLimit": -1,
  				"hardLimit": -1
  			},
  			{
  				"Name": "stack",
  				"softLimit": -1,
  				"hardLimit": -1
  			}

  		],
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
