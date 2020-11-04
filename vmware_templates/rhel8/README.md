# vmware template with Packer (vsphere-iso)

The following resources are required in order to provision a template using the vsphere-iso
provisioner.

- vsphere/vcenter 7.0
- terraform v0.12.21
- packer v1.6.5
- rhel 8.x iso file

Usually you can use the .HTTP and .HTTPIP services with Packer, but this 
doesn't seem to work anymore. So, what will need to be done instead is to 
generate a small iso file with the OEMDRV label added which allows the kickstart to happen.

To create the boot iso:
`genisoimage -o rhel8.2-ks.iso -V "OEMDRV" ks.cfg`

Then upload the iso into the datastore which is accessible for the vm creation.

After the OEM iso file is uploaded, along with the newly minted kickstart iso, then you can 
run `packer build rhel8.json`. If you watch the console in vCenter you can see the machine
getting created and hit the console and watch the build process.


1. Download and install Packer
2. Customize kickstart (ks.cfg) file
3. Fill out variables in rhel8.json build file
4. Run `packer build rhel8.json`
