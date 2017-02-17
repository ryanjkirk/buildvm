createvm
========

This playbook is designed to connect to vSphere and create a VM using the specs you provide. Specifically, it will clone a VM from a pre-existing VMware template (the naming here is important -- adapt to your own needs). You can then bootstrap puppet or anything else to achieve the full configuration by connecting to it directly. This portion of the playbook depends on the server becoming available at that hostname (likely via dhcp).

Dependencies
------------

Ansible and python 2.6+, of course.

Python modules
* https://github.com/vmware/pyvmomi

Ansible modules
* https://github.com/ViaSat/ansible-vsphere

Running the playbook
--------------------

Required vars to pass using --extra-vars:
 * *vcenter* -              vCenter hostname or IP
 * *login* -                vCenter login in user@domain format, eg: user@domain
 * *password* -             vCenter
 * *newvmhostname* -        either the new VM single hostname or ENV name
 * *folder* -               vSphere folder to place the VM in

 Optional vars:
 * *mbram* -                VM memory. if left unspecified, defaults to 2048
 * *numcpus* -              VM vCPUs. If left unspecified, defaults to 2
 * *elver* -                CentOS major release version, defaults to 7

Sample run command
-----------------

    ansible-playbook createvm.yml --extra-vars="vcenter=${vcenter} login=${user} password='${password}' newvmhostname='${newvmhostname}' folder=SharedVMs mbram=4096 numcpus=2" --ask-pass -i "${newvmhostname},"
