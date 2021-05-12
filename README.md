## x728.sh
setup scripts for x728

## x728bat_v1.3.py
 >IMPORTANT!!!
 
* This is low voltage automatic shutdown script only to the X728 series (`V1.1, V1.3, V1.5` version, `BUT DON'T` support future V2.0 version), and it will help you to implement the software automatic shutdown function when the battery is low voltage.
* Once this script is installed. Please charge your batteries when battery low, otherwsie your Raspberry Pi cannot boot up again.
* If you have some questions, please contact to: support@geekworm.com
---
But we hope that the script can be executed automatically when the Raspberry Pi board boots, we can use crontab system command to achieve it. please refer to the following:

>pi@raspberrypi ~ $  `sudo crontab -e` 
 
 Choose "`1`" then press Enter

 Add a line at the end of the file that reads like this:
 
>`@reboot python3 /home/pi/x728bat_v1.3.py`
  

