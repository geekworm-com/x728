This shell script and python file is tested only on Raspberry pi OS..
## x728-v1.0.sh
setup scripts for x728 v1.2/v1.3

Guide: https://wiki.geekworm.com/X728-Software

## x728-v2.0.sh
setup scripts for x728 v2.0 only

## User manual
Firstly please select your x728 version.
>sudo bash x728-v1.0.sh

> or

>sudo bash x728-v2.0.sh

>printf "%s\n" "alias x728off='sudo x728softsd.sh'" >> ~/.bashrc

>sudo reboot

You can get the following python file in /home/pi/ fold:

 x728bat.py # Reading battery voltage

 x728pld.py # Testing AC power off/loss or power adapter failure detection

But we hope that the script can be executed automatically when the Raspberry Pi board boots, we can use crontab system command to achieve it. please refer to the following:

>pi@raspberrypi ~ $  `sudo crontab -e`

 Choose "`1`" then press Enter

 Add a line at the end of the file that reads like this:

>`@reboot python /home/pi/x728bat.py`

## uninstall_x728.sh
uninsatll x728 shell script, run the following command:
> sudo ./uninstall_x728.sh



