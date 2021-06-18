#!/bin/bash
#remove x728 old installtion
sudo sed -i '/x728/d' /etc/rc.local
sudo sed -i '/x728/d' /etc/modules
#sudo rm /home/pi/x728*.py -rf
echo 'please remove old python file such x728xx.py on /home/pi/ fold'
