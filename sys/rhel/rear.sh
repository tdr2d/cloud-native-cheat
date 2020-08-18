#!/bin/sh

# install
yum install rear genisoimage syslinux

# eg: https://github.com/rear/rear/tree/289c0f60f26eea048f13a03a559eb0a315689aef/usr/share/rear/conf/examples
cat << EOF > /etc/rear/local.conf
OUTPUT=ISO
BACKUP=NETFS
BACKUP_OPTIONS="nfsvers=3,nolock"
BACKUP_URL=nfs://nfs-server-address/path/to/images
NETFS_KEEP_OLD_BACKUP_COPY=y
BACKUP_PROG_EXCLUDE+=( '/usr/openv/tmp/*' '/nbu/logs/openv/logs/nbdisco/*' '/nbu/logs/openv/logs/nbsvcmon/*' '/nbu/logs/openv/logs/nbrmms/*' '/nbu/logs/openv/logs/nbsl/*' )
EOF

rear checklayout || rear mkrescue

# /etc/crontab
# minute hour day_of_month month day_of_week root /usr/sbin/rear mkrescue
# 0 22 * * 1-5 root /usr/sbin/rear mkrescue # 22:00 every weekday

# Recovery:
# rear -C basic_system recover
# rear -C home_backup restoreonly