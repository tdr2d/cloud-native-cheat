#!/bin/sh

# Install
curl -L https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip | gunzip > /usr/local/bin/vault
chmod +x /usr/local/bin/vault
vault -autocomplete-install
exec $SHELL

# Use the key/value engine to create/get/delete secret keys
vault kv put secret/hello foo=world # writes the pair foo=world to the path secret/hello
vault kv put secret/hello foo=world excited=yes

vault kv get secret/hello # get secret/hello keys
vault kv get -format=json secret/hello # get json
vault kv get -field=excited secret/hello # get specific key

vault kv delete secret/hello # delete

# Start a vault server
sudo mkdir -p /var/vault/data /etc/vault/
cat << EOF > /etc/vault/config.hcl
storage "file" {
  path = "/var/vault/data"
}

listener "tcp" {
 address     = "127.0.0.1:8200"
 tls_disable = 1
}
EOF

cat << EOF > /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets" Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target ConditionFileNotEmpty=/etc/vault/config.hcl StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF
systemctl enable vault && systemctl start vault
vault server -config=/etc/vault/config.hcl

vault operator init # initialize vault agents, generate 4 private keys and 1 root token


