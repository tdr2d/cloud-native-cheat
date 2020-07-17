velero_install:
	wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.2/velero-v1.3.2-linux-amd64.tar.gz
	tar -xvf velero-v1.3.2-linux-amd64.tar.gz
	cp velero-v1.3.2-linux-amd64/velero /usr/local/bin/velero
	chmod +x /usr/local/bin/velero
	rm -rf velero-v1.3.2-linux-amd64.tar.gz velero-v1.3.2-linux-amd64

vsphere:
	echo "https://github.com/vmware-tanzu/velero-plugin-for-vsphere"
	velero plugin add vsphereveleroplugin/velero-plugin-for-vsphere:1.0.0

	# create a VolumeSnapshotLocation
	velero snapshot-location create vsl-vsphere --provider velero.io/vsphere

	# Backup using the plugin
	velero backup create my-backup --include-namespaces=my-namespace --snapshot-volumes --volume-snapshot-locations vsl-vsphere

	# lock backup objects
	kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadOnly"}}'

	# Restore
	velero restore create --from-backup my-backup

	# Unlock backup objects
	kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
   --namespace velero \
   --type merge \
   --patch '{"spec":{"accessMode":"ReadWrite"}}'

	# Cron
	velero schedule create <SCHEDULE NAME> --schedule "0 7 * * *"
