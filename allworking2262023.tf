locals {
  directoryid     = var.directoryid
  directoryname   = var.directoryname
  mac1            = "aws_instance.ec2_instance[count.index].network_interface[0].mac_address"
  mac2            = "aws_instance.ec2_instance[count.index].network_interface[1].mac_address"
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
sudo cp -r /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.old
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'13i\n            routes:  \n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'14i\n            - to: 10.128.15.176/32\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'15i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'16i\n            - to: 10.128.9.164/32\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'17i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'18i\n            - to: 10.128.14.160/32\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'19i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'20i\n            - to: 10.254.0.0/22\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'21i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'22i\n            - to: 169.254.169.254/32\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'23i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'24i\n            - to: 10.246.0.0/20\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'25i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'26i\n            - to: 10.128.0.0/16\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'27i\n              via: 10.128.0.1\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'30i\n            routes:  \n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'31i\n            - to: 0.0.0.0/0\n.\nwq'
sudo ed -s /etc/netplan/50-cloud-init.yaml <<< $'32i\n              via: 10.254.13.1\n.\nwq'
sudo netplan apply
sudo snap stop amazon-ssm-agent
sudo snap start amazon-ssm-agent
sudo touch /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
sudo echo "network: {config: disabled}" >> /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg   
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
#echo "$ip a" >> /tmp/seconduserdatalos.log
EOF
    },
    #/* 
    {
      ami           = "ami-09988af04120b3591" #"ami-01f18be4e32df20e2"
      instance_type = "c6id.4xlarge"
      subnet_id     = "subnet-0acc6770b79dde778" #"subnet-0acc6770b79dde778"
      key_name      = "rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 2
# Add your user data script here
#sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
sudo yum -y update
sudo mv /etc/dhcp/dhclient-eth1.conf /etc/dhcp/dhclient-eth1.conf.old
sudo touch /etc/dhcp/dhclient-eth1.conf
sudo echo "timeout 300;" >> /etc/dhcp/dhclient-eth1.conf
sudo dhclient 
sudo echo "GATEWAY=10.254.13.1" >> /etc/sysconfig/network
sudo service network restart
sudo ip route add 10.246.0.0/20 via 10.128.0.1 dev eth0
sudo ip route add 10.254.0.0/22 via 10.128.0.1 dev eth0
sudo echo "10.246.0.0/20 via 10.128.0.1 dev eth0" >> /etc/sysconfig/network-scripts/route-eth0
sudo echo "10.254.0.0/20 via 10.128.0.1 dev eth0" >> /etc/sysconfig/network-scripts/route-eth0
sudo service network restart
#sudo ip route replace default via 10.254.13.1 dev eth1 >> /tmp/userdatalog.log
sudo yum install -y awscli
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh && sudo chmod 755 /tmp/joinAD_SSM.sh
#sudo /tmp/joinAD_SSM.sh --directory-id ${var.directoryid} --directory-name ${var.directoryname}
sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46 >> /tmp/userdatalos.log
#sudo /usr/bin/sed -i "s/eth0/ens5/g" /tmp/joinAD_SSM.sh
#sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
#/tmp/joinAD_SSM.sh --directory-id d-90674e9d97 --directory-name mmp2.vzmec.com
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#sudo systemctl restart sshd.service
echo "%mmp2vzmec\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers 
#aws s3 cp s3://vzmmp2-outpost-amitest/Crowdstrike/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm /tmp
sudo yum install -y /tmp/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm
sudo service falcon-sensor start
EOF
    } 
  #*/  
  ]
}

# Create the VPC network interface
resource "aws_network_interface" "vpc_interface" {
  count             = length(local.instance_configs)
  #subnet_id         = local.instance_configs[0].subnet_id
  subnet_id         = local.instance_configs[count.index].subnet_id
  #subnet_id         = "aws_subnet.outpost.id[0]"
  security_groups      = [aws_security_group.instance_sg.id]
  #security_groups = [
  #  aws_security_group.instance_sg.id,
  #  aws_security_group.additional_sg.id
  #]
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
  #security_groups      = ["sg-0322e0a60771c9561"]
  #security_groups = [
  #  aws_security_group.instance_sg.id,
  #  aws_security_group.additional_sg.id
  #]
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
  #count         = 2
  #security_groups      = ["sg-0322e0a60771c9561"]
  

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
    #security_groups      = ["sg-0322e0a60771c9561"]
    #security_groups      = ["security-group-id"] // Replace with the security group ID for the new interface
    #source_dest_check    = true
    #security_groups = [
    #aws_security_group.instance_sg.id,
    #aws_security_group.additional_sg.id
  #]
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
/*
variable "elastic_ips" {
  type = list(string)
  default = ["34.198.171.200","34.202.22.8"]
}

data "aws_eip" "elastiip" {
  count = length(var.elastic_ips)
  public_ip  = var.elastic_ips[count.index] #"52.22.165.196" #"52.70.217.22"
}
*/
#working
#data "aws_eip" "elastiip" {
#  public_ip  = "34.198.171.200" #,"34.202.22.8"] #"52.22.165.196" #"52.70.217.22"
#}
/*
#Associate EIP with EC2 Instance
resource "aws_eip_association" "demo-eip-association" {
  #count = length(var.instance_configs)
  count = length(local.instance_configs)
  #instance_id   = aws_instance.ec2_instance[count.index].id #aws_instance.ec2_instance[count.index].id
  network_interface_id = aws_network_interface.vpc_interface[count.index].id #aws_network_interface.vpc_interface.id
  #network_interface_id = aws_network_interface.example[count.index].id #aws_network_interface.example[count.index].id
  allocation_id = data.aws_eip.elastiip[count.index].id
}
*/

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


resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Security group for EC2 instances"
  vpc_id      = "vpc-038d9b7cd29b43879"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
/*
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
*/
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}
/*
resource "aws_security_group" "additional_sg" {
  name        = "additional-security-group"
  description = "Additional security group for EC2 instances"
  vpc_id      = "vpc-038d9b7cd29b43879"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "additional-security-group"
  }
}
*/
