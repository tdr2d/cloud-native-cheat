
# nextcloud env
k delete secret nextcloud-env
k create secret generic nextcloud-env --from-env-file=.env-nextcloud

# Start from: k create deploy nextcloud --image=nextcloud:27.0.1-fpm-alpine --dry-run -o yaml
# add nginx container
# use nginx config via a configmap 
# create emptyDir volume to share php code between nextcloud and nginx containers 
# add config.php via a configmap
# create secrets via CLI secretly, see config.php
# month secret in nextcloud container as env
k create cm php-fpm-conf --from-file=default.conf=nginx-php-fpm.conf

k delete deploy nextcloud
k delete cm nextcloud-config
k create cm nextcloud-config --from-file=custom.config.php=custom.config.php
k apply -f deployment.yml

k logs -l app=nextcloud --tail=-1 -f

# Exposition
k expose deploy nextcloud --port 80 --target-port=80
k create ingress nextcloud-tls --rule="nextcloud.example.com/*=nextcloud:80,tls=nextcloud-cert" --class nginx \
    --annotation cert-manager.io/cluster-issuer=letsencrypt \
    --annotation nginx.ingress.kubernetes.io/client-body-buffer-size=10m \
    --annotation nginx.ingress.kubernetes.io/proxy-body-size=200m \
    --annotation nginx.ingress.kubernetes.io/proxy-max-temp-file-size=10240m


# Problem with read-only configuratiion
# 
# "Config is set to be read-only via option "config_is_read_only". Unset "config_is_read_only" to allow changes to the config file."


## TIPPS
# When creating secret using env-file, DONT use ' or " characters
# Dont comment the config.php file 


# for Postgresql DONT use a dbname with an hyphen you'll the this same error 
# https://github.com/nextcloud/server/issues/37114

# DONT use nextcloud-php-fpm-alpine container, use the default nextcloud-php-fpm one
# nextcloud-php-fpm-alpine bug with tls certificates when using postgresl with tls enabled
# https://gitlab.alpinelinux.org/alpine/aports/-/issues/14565

# If you have this error from nextcloud The username is already being used, Retrying install...
# you must delete you database and recreate it. Nextcloud install is not 

# Log config just does not work, the log file is located in /var/www/html/data/nextcloud.log
# So you can't redirect the log to /dev/stdout
# Config 'logfile' => '/dev/stdout' does not work
k exec -i -t nextcloud-769cc9bd75-5xmlm -- tail -f data/nextcloud.log

# Nextcloud modifies you config.php after install
# If you restart the app, it will not work unless you save the config.php
# you have to update the config and set 'installed' => true, then restart your deployment

# Finally all of this to get : Configuration was not read or initialized correctly, not overwriting /var/www/html/config/config.php
# ...


# TLDR
# Throw the stateless deployment in the trash. Nextcloud uses too much hacks.
# Use a Statefulset, nextcloud configurations are not stateless at all
k apply -f statefulset.yml
k expose pod nextcloud-0 --name=nextcloud --port 80 --target-port=80
k logs -l app=nextcloud --tail=-1 -f
# then manually add all your password and config
# Dont use s3 integration, nobody wants to pay for traffic.
# Dont think about optimizing performance with php-fpm if you have a ReadWriteOnce Volume, it does not work...
# Who needs postgresql in the first place ? Sqlite works just fine...