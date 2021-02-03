Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
users:
    - name: minetest
      groups: users, admin
      sudo: ALL=(ALL) NOPASSWD:ALL
      shell: /bin/bash
      ssh_authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDH6orvm7dzkp47YBEvxOk3cvvYR5io32OmbbnR96bGjlT7LZleL4oV/aozCAG4Axy6mgByULUsxG9l/JhmFa3zg0/rP9HrklX7oPNdAdN26QAquD6dgaZ3PFP7UXkkNaTTAmJcw02EaCNuCcGLGinKOi0LETN/K+BTfpL7Q5kUbWFnkDjJpiIjqZwNzBqU3G7OfbqpW+EbcCAouBkT+rE09lAUth5BXWgq7MhtF8LrfnIrrf0demkXqqYm2clXd5266M2LgCsu/LayMkO0ig4SH7DotgXxNeXLJQtu7E02rrxFTZuNvazQQ7TwBbZdDELmYB8BdRmTQjYZqMSw6zaf
packages:
    - fail2ban
    - ufw
package_update: true
package_upgrade: true
runcmd:
#    - printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
#    - systemctl enable fail2ban
    - ufw allow OpenSSH
    - ufw enable
    - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
    - sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
    - sed -i -e '/^X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
    - sed -i -e '/^#MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
    - sed -i -e '/^#AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
    - sed -i -e '/^#AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
    - sed -i -e '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
    - sed -i '$a AllowUsers desixma' /etc/ssh/sshd_config
    - sleep 5
#    - apt update -y
#    - apt install hcloud-cli

cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"
#!/bin/bash

# temporary fix due to a hcloud provisioner issue
if [[ $(lsblk -n /dev/sdb | awk -F' ' '{print $7}') == "" ]] ; then
      mkdir -p /usr/share/disk
      mount /dev/sdb /usr/share/disk
fi
#end of fix

# link target to Hetzner mount
if [[ $(lsblk -n /dev/sdb | awk -F' ' '{print $7}') == "/mnt/HC_Volume_${disk_id}" ]] ; then
      ln -s /mnt/HC_Volume_${disk_id} /usr/share/disk
fi

# allow external access
ufw allow 30000/udp
ufw allow 30000/tcp
ufw reload

# get base software for bootstrapping: ansible and git
apt-get -y update
apt install -y ansible
apt install -y git

# create bootstrap location
mkdir -p /opt/bootstrap
cd /opt/bootstrap

# get the bootsload project
git clone https://github.com/selfscrum/minetest-edu-server

# create a playbook to run locally
cat > start.yml << EOF
- name: Install Minetest
  hosts: localhost
  roles:
    - minetest-edu-server
EOF

export MT_DEFAULT_PASSWORD=${mt_default_password}
export MT_VERSION=${mt_version}
export MT_SERVER_NAME=${mt_server_name}
export MT_SERVER_DESCRIPTION=${mt_server_description}
export MT_BIND_ADDRESS=${mt_bind_address}
export MT_BIND_PORT=${mt_bind_port}
export MT_ADMIN_NAME=${mt_admin_name}

# run the playbook
ansible-playbook start.yml

# start additional mods if present

