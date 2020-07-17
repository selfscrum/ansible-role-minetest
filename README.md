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
        - nautik1.teeworlds
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
