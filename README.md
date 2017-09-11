# Building the cBioportal local instance

# Developing scripts with several programming languages in order to automate processes such as gene mutation annotation, data validation and loading

# Monitoring and updating databases in order to maintain data accuracy and eliminate data discrepancies


#Before we are learning how to perform bionformatic data analysis, we need to set up the ubuntu 16.04 LTS linux system.
#one step I want to point out is that it is much better for the linux beginner to partition the disk as below.
#For simplicity, we partition 3 disks: 
/ # one is for boot, if you have enough disk space, please allocate more than 100 GB for boot.

swap # one is for swap, basically, It is allocated twice size with your RAM, if you RAM is 32 GB, please allocate 64 GB for swap

/data # one is for data, all the left disk space are allocated to data disk. 

#After installtion of your ubuntu operation system, you may need to set up static IP address:
#First thing you need to do is to enable SSH in ubuntu 16.04.
sudo apt-get install openssh-server
sudo vim /etc/ssh/sshd_config   // you may need install vim, to do this, please run sudo apt-get install vim or you can run sudo nano /etc/ssh/sshd_config
change Permit RootLogin to yes
#then go to /etc/network/interfaces folder to set up the static IP address
sudo vim /etc/network/interfaces or sudo nano /etc/network/interfaces

#interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback
#change to 

auto eth0
iface eth0 inet static
address 192.168.107.160
gateway 192.168.107.2 // you could get the infor from the properties of your network
netmask 255.255.255.0
dns-nameservers 8.8.8.8

#and then, go to /etc/NetworkManager/NetworkManager.conf folder
sudo vim /etc/NetworkManager/NetworkManager.conf  or sudo nano /etc/NetworkManager/NetworkManager.conf
[if updown] managed = false  // change false to true
