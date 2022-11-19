# Odoo docker-compose file
## Start Odoo instance using external Database
<br>
<br>

# Usage :
```
docker compose -f odoo.yml up -d
```
## docker-compose.yml file
```yaml
# odoo.yml
# Bug in default dockercompose file https://hub.docker.com/_/odoo
# Fixed here https://github.com/odoo/odoo/issues/27447#issuecomment-487608279
version: '3.1'
services:
  web:
    image: odoo:14.0
    entrypoint: odoo
    command: --db_host=postgresql-976d2ff4-o992bd81e.database.cloud.ovh.net --database postgres --db_user avnadmin --db_password esTn73ZE9zBr68vwxMkc --db_port 20184 -i base
    ports:
      - "8069:8069"
    environment:
      - HOST=postgresql-976d2ff4-o992bd81e.database.cloud.ovh.net
      - USER=avnadmin
      - PASSWORD=esTn73ZE9zBr68vwxMkc
      - PORT=20184
```
