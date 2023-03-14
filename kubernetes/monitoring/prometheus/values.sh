extraScrapeConfigs:
  - job_name: 'node-exporter-postgresql-cluster'
    static_configs:
      - targets:
        - http://162.19.54.210:9100