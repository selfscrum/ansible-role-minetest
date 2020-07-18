Ansible-role-minetest
=====================

This role helps installing a Minetest server.

Requirements
------------

Any debian-based linux should work, preferably Ubuntu 20.04.

Tested with:
- Minetest 5.3.0
- Ansible 2.9.10
- Ubuntu 20.04 on [Gandi Cloud](https://www.gandi.net/fr/cloud)

Role Variables
--------------

| Variable              | Description                                                                                                  | Example                                   |
|-----------------------|--------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `minetest_version`     | The version of the Minetest server to download and install                                                      | `5.3*`                                     |
| `server_name`     | The public name of the Minetest server                                                      | `Minetest server`                                     |
| `server_description`     | The public description of the Minetest server                                                      | `Welcome to my Minetest Server`                                     |
| `bind_address`     | The ip address to bind to                                                      | `0.0.0.0`                                     |
| `bind_port`     | The server port on which Minetest will be exposed                                                      | `30000`                                     |
| `admin_username`     | The username of the user that will be named admin when joining                                                      | empty                                     |
| `extra_configuration`     | Any other minetest configuration in format `key=value` (one per line), see https://wiki.minetest.net/Minetest.conf                                                       | empty                                     |

Dependencies
------------

No dependency, Minetest installed from their stable ppa: https://launchpad.net/~minetestdevs/+archive/ubuntu/stable

Example Playbook
----------------

Sample playbook:

```
    - name: Install Minetest
      hosts: all
      roles:
        - nautik1.minetest
```

Sample inventory:

```
all:
  hosts:
    <ip-or-hostname>:
  vars:
    minetest_version: 5.3*
```

License
-------

[WTFPL](https://en.wikipedia.org/wiki/WTFPL)
