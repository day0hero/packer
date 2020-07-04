# RHEL7 - Vanilla Installationn

This build installs a RHEL-7.8 base image with LVM. The LVM layout can be altered by changing the kickstart file in the http directory. I ran this from a Fedora 31 machine using `packer v1.6.0`. The image provisions a 40G thin provisioned qcow2 image that is carved up with LVM. 

1. Download packer for your OS version: https://www.packer.io/downloads
2. Create a working directory for your installation: ex: ~/projects/packer
3. Create the following directories:
|directory|purpose|
|------|------|
|iso | Local directory for the os iso file|
| http | Place where packer looks for the ks.cfg |
4. Start developing the kickstart file - Use the template in the 'http' directory as a guideline. Make sure 
that you update the passwords to fit your nees.
5. Start on the rhel7.json - this is the template that packer uses to build the image.


## Breaking apart the packer build template
```
{
  "variables": {
    "rhel_password": "root_password_set_in_kickstart",
    "version": "7.8",
    "http_ip": "ip_of_server_hosting_iso_file_for_network_installations"
  },
```
```
  "builders": [{
      "vm_name": "rhel-packer",
      "iso_urls": [
	      "/absolute_path_of_iso/rhel-server-{{ user `version` }}.iso",
	      "http://{{ user `http_ip` }}/rhel-server-{{ `version` }}.iso"
       ],
      "iso_checksum": "none",
      "iso_target_path": "iso",
      "accelerator": "kvm",
      "output_directory": "output-rhel7",
      "ssh_username": "root",
      "ssh_password": "{{ user `rhel_password` }}",
      "ssh_wait_timeout": "20m",
      "pause_before_connecting": "10m",
      "headless": "true",
      "http_directory": "http",
      "boot_command": [
        "<tab> inst.sshd inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort}}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "2s",
      "shutdown_command": "echo 'packer' | sudo -S shutdown -P now",
      "type": "qemu",
      "memory": 4096,
      "cpus": 4
    }],
```

```
  "provisioners": [{
  "type": "shell",
  "inline": ["sudo cp /etc/hosts /etc/hosts.bak"]
  },
  {
  "type": "file",
  "source": "/home/<local_user_key_to_pass>/.ssh/id_rsa.pub",
  "destination": "/home/packer/.ssh/authorized_keys"
  },
  {
  "type": "ansible",
  "playbook_file": "ansible/playbook.yml"
  },
  {
  "type": "shell",
  "inline": [ "sudo mv /etc/hosts.bak /etc/hosts" ]
  }]
```
}

