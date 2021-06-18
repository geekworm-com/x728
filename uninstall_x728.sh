#!/bin/bash
#remove x728 old installtion
sudo sed -i '/x728/d' /etc/rc.local
sudo sed -i '/x728/d' /etc/modules
sudo sed -i '/x728/d' ~/.bashrc

sudo rm /home/pi/x728*.py -rf
sudo rm /usr/local/bin/x728softsd.sh -f
sudo rm /etc/x728pwr.sh -f
#echo 'please remove old python file such x728xx.py on /home/pi/ fold'
