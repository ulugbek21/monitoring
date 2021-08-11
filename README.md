# Monitoring with Prometheus and Grafana

Copy sample configs to actuals.

    make copy-sample-configs

Modify the following list of copied files accordingly:

- monitoring/blackboxprober/config.yml

- monitoring/alertmanager/config.yml

- monitoring/prometheus/prometheus.yml

- monitoring/prometheus/service.yml

Create .env file from env.example by running and modify it:

    make create-env

Start monitoring services:

    make up

Restart monitoring services:

    make restart

Stop and remove monitoring services:

    make down