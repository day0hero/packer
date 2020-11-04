#!/bin/bash 
satellite_ip=192.168.1.73
satellite_fqdn=satellite.clusterfudge.net
satellite_activationkey=rhel
satellite_organization=CFDG

#Add Satellite information to /etc/hosts
sudo echo -e "${satellite_ip}\t\t${satellite_fqdn}" >> /etc/hosts

#Download and install katello rpm from satellite
sudo yum localinstall -y ${satellite_fqdn}/pub/katello-ca-consumer-latest.noarch.rpm 

#Register to satellite
sudo subscription-manager register --activationkey ${satellite_activationkey} --org_id ${satellite_organization}

#Install some packages
sudo yum -y install git

#Update all the things
sudo yum update -y 

#Remove yum cache
sudo yum clean all 

#Unregister machine from the satellite
sudo subscription-manager unregister

#Clean up RHSM stuff put in place by satellite
sudo subscription-manager clean 

#Remove katello rpm from server
sudo rpm -e $(rpm -qa | grep katello-ca)
sudo rpm -e $(rpm -qa | grep epel)


