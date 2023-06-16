locals {
  directoryid     = var.directoryid
  directoryname   = var.directoryname
  instance_configs = [
    {
      ami           = "ami-01f18be4e32df20e2"
      instance_type = "c6id.4xlarge"
      subnet_id     = "subnet-0acc6770b79dde778"
      #subnet_id    = "aws_subnet.outpost.*.id[0]"
      #subnet_id     = aws_subnet.outpost.*.id
      #subnet_id     = module.mmp2_vpc.public_subnet_ids[0]
      key_name      = "rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 1
# Add your user data script here
#!/bin/bash
ip a > /tmp/userdatalos.log
ping -c 10 -w 5 8.8.8.8 >> /tmp/userdatalosping.log
ping -c 10 -w 5 8.8.8.8 -I ens6 >> /tmp/userdatalospingens6.log 
ping -c 10 -w 5 8.8.8.8 -I ens5 >> /tmp/userdatalospingens5.log
sudo apt-get -y update >> /tmp/userdatalos.log
sudo apt-get -y install awscli >> /tmp/userdatalos.log
sudo apt install traceroute -y >> /tmp/userdatalos.log
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh >> /tmp/userdatalos.log
sudo chmod 755 /tmp/joinAD_SSM.sh  >> /tmp/userdatalos.log
sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46 >> /tmp/userdatalos.log
#sudo /bin/bash /tmp/joinAD_SSM.sh --directory-id ${var.directoryid} --directory-name ${var.directoryname} >> /tmp/userdatalos.log
sudo echo "session required pam_mkhomedir.so skel=/etc/skel umask=00" >> /etc/pam.d/common-session >> /tmp/userdatalos.log
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config >> /tmp/userdatalos.log
sudo systemctl restart sshd.service >> /tmp/userdatalos.log
echo "%mmp2vzmec\\\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers
sudo mkdir /mnt/${var.nfs-aws-netapp}  >> /tmp/userdatalos.log
sudo apt install nfs-common -y  >> /tmp/userdatalos.log
sudo apt install net-tools -y >> /tmp/userdatalos.log
route add -net 10.254.4.0 netmask 255.255.255.0 gw 10.254.13.1 >> /tmp/userdatalos.log
echo "10.254.4.39:/br_pmec_netapp_aws_nfs /mnt/${var.nfs-aws-netapp} nfs   defaults  0   0" >> /etc/fstab
mount -t nfs 10.254.4.39:/br_pmec_netapp_aws_nfs /mnt/${var.nfs-aws-netapp} >> /tmp/userdatalos.log
ip route >> /tmp/userdatalos.log
ip a >> /tmp/userdatalos.log
echo "########"
ping -c 10 -w 5 8.8.8.8 >> /tmp/userdatalosping.log
ping -c 10 -w 5 8.8.8.8 -I ens6 >> /tmp/userdatalospingens6.log 
ping -c 10 -w 5 8.8.8.8 -I ens5 >> /tmp/userdatalospingens5.log
echo "$ip a" >> /tmp/seconduserdatalos.log
sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.old
sudo touch /etc/netplan/50-cloud-init.yaml
cat <<EOT > /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        ens5:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 100
            dhcp6: false
            routes:
            - to: 10.128.0.0/16
              via: 10.128.0.1
            - to: 169.254.169.254/32
              via: 10.128.0.1
            - to: 10.246.0.0/20
              via: 10.128.0.1
            - to: 10.254.0.0/22
              via: 10.128.0.1
            match:
                macaddress: "${aws_network_interface.vpc_interface.mac_address}" #0a:08:85:f2:a1:eb
            set-name: ens5

        ens6:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 200
            dhcp6: false
            routes:
            - to: 0.0.0.0/0
              via: 10.254.13.1
            match:
                macaddress: "${aws_network_interface.new_interface.mac_address}" #0a:65:43:64:e1:33
            set-name: ens6
    version: 2
EOT  
EOF
    }#,
    /*
    {
      ami           = "ami-01f18be4e32df20e2"
      instance_type = "c6id.4xlarge"
      subnet_id     = "subnet-0acc6770b79dde778"
      key_name      = "rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 2
# Add your user data script here
sudo apt-get -y update
sudo apt-get -y install awscli
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh
sudo chmod 755 /tmp/joinAD_SSM.sh
sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
#sudo yum -y update
#sudo yum install -y awscli
#sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh && sudo chmod 755 /tmp/joinAD_SSM.sh
#/bin/bash /tmp/joinAD_SSM.sh --directory-id ${var.directoryid} --directory-name ${var.directoryname}
#sudo /usr/bin/sed -i "s/eth0/ens5/g" /tmp/joinAD_SSM.sh
#sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
#/tmp/joinAD_SSM.sh --directory-id d-90674e9d97 --directory-name mmp2.vzmec.com
#sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#sudo systemctl restart sshd.service
#echo "%mmp2vzmec\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers 
#aws s3 cp s3://vzmmp2-outpost-amitest/Crowdstrike/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm /tmp
#sudo yum install -y /tmp/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm
#sudo service falcon-sensor start
EOF
    } 
  */  
  ]
}

# Create the VPC network interface
resource "aws_network_interface" "vpc_interface" {
  count             = length(local.instance_configs)
  subnet_id         = local.instance_configs[0].subnet_id
  #subnet_id         = "aws_subnet.outpost.id[0]"
  #subnet_id         = aws_subnet.outpost.*.id[0]
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create the new network interface
resource "aws_network_interface" "new_interface" {
  count             = length(local.instance_configs)
  #subnet_id         = local.instance_configs[1].subnet_id
  subnet_id         = local.instance_configs[count.index].subnet_id
  #subnet_id     = aws_subnet.outpost.*.id[0]
  #subnet_id         = local.instance_configs[0].subnet_id
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create the EC2 instances
resource "aws_instance" "ec2_instance" {
  count = length(local.instance_configs)

  ami           = local.instance_configs[count.index].ami
  instance_type = local.instance_configs[count.index].instance_type
  #subnet_id     = local.instance_configs[count.index].subnet_id
  key_name      = local.instance_configs[count.index].key_name
  user_data     = local.instance_configs[count.index].user_data
  iam_instance_profile  = "PMec-LinuxEC2DomainJoin"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpc_interface[count.index].id #"eni-0887e0adf3fdf18ba" #aws_network_interface.vpc_interface.id
    #network_interface_id = "existing-interface-id" // Replace with your existing interface ID
  }

  network_interface {
    device_index         = 1
    #subnet_id            = local.instance_configs[count.index].subnet_id
    ###network_interface_id = aws_network_interface.new_interface.id
    network_interface_id = aws_network_interface.new_interface[count.index].id
    #security_groups      = ["security-group-id"] // Replace with the security group ID for the new interface
    #source_dest_check    = true
  }

  tags = {
    Name = "br-ins-${count.index + 1}"
  }
}
/*
# Associate existing Elastic IP with the existing network interface
resource "aws_eip_association" "existing_interface_eip_association" {
  instance_id             = aws_instance.ec2_instance[0].id
  network_interface_id    = "existing-interface-id" // Replace with your existing interface ID
  allocation_id           = "eip-allocation-id" // Replace with the allocation ID of your Elastic IP
}
*/

variable "elastic_ips" {
  type = list(string)
  default = ["34.198.171.200","34.202.22.8"]
}

data "aws_eip" "elastiip" {
  count = length(var.elastic_ips)
  public_ip  = var.elastic_ips[count.index] #"52.22.165.196" #"52.70.217.22"
}

#working
#data "aws_eip" "elastiip" {
#  public_ip  = "34.198.171.200" #,"34.202.22.8"] #"52.22.165.196" #"52.70.217.22"
#}

#Associate EIP with EC2 Instance
resource "aws_eip_association" "demo-eip-association" {
  #count = length(var.instance_configs)
  count = length(local.instance_configs)
  #instance_id   = aws_instance.ec2_instance[count.index].id #aws_instance.ec2_instance[count.index].id
  network_interface_id = aws_network_interface.vpc_interface[count.index].id #aws_network_interface.vpc_interface.id
  #network_interface_id = aws_network_interface.example[count.index].id #aws_network_interface.example[count.index].id
  allocation_id = data.aws_eip.elastiip[count.index].id
}


/*
resource "aws_eip_association" "eip_disassociation" {
  #instance_id = aws_instance.ec2_instance.id
  #provider  = aws.demo-eip-association.provider
  network_interface_id = aws_network_interface.vpc_interface.id
  allocation_id = data.aws_eip.elastiip.id

  lifecycle {
    create_before_destroy = true
    #ignore_changes = [instance_id]
    #ignore_changes = [network_interface_id]
  }
}
*/
resource "aws_subnet" "outpost" {
  count = length(var.outpost_subnets)
  vpc_id = module.mmp2_vpc.vpc_id
  cidr_block = var.outpost_subnets[count.index]
  availability_zone = var.outpost_az

  outpost_arn = var.outpost_arn

  tags = {
    Name = "eulass-outpost"
    Owner = var.owner
  }
}

resource "aws_route_table" "outpost_route_table" {
  vpc_id = module.mmp2_vpc.vpc_id

  tags = {
    Name = "${var.resource_name_prefix}-outpost-route-table"
    Owner = var.owner
  }
}
