# vmware template with Packer (vsphere-iso)

The following resources are required in order to provision a template using the vsphere-iso
provisioner.
- vsphere/vcenter 7.0
- packer v1.6.5
- rhel-7.x iso file
- terraform v0.12.21

Your version of Terraform is out of date! The latest version
is 0.13.5. You can update by downloading from https://www.terraform.io/downloads.html
1. Download and install Packer
2. Customize kickstart (ks-rh7.cfg) file
3. Populate variables in rhel7.json file
4. Run `packer build rhel7.json`

```
Using efi as the firmware mode will cause the boot command to fail. Using BIOS allows the boot command
to properly interrupt the boot process and add the required arguments to provision the template.
```
