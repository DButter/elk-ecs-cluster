[
    {
      "name": "${name}",
      "image": "${container_image}",
      "essential": true,
      "portMappings": [],
      "entryPoint": [
  			"python",
  			"es_test_data.py",
  			"--es_url=${default_url}",
        "--batch_size=${batch_size}",
        "--count=${count}",
        "--http_upload_timeout=${http_upload_timeout}"
  		],
      "environment": [
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
            "awslogs-stream-prefix": "elastic_load_generator.json"
        }
      }
    }
]
