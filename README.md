This shell script and python file is tested only on Raspberry pi OS..

We refactored the script file of X728, hope it will be easier to use

Guide: https://wiki.geekworm.com/X728-Software

## x728-v1.0.sh
setup scripts for x728 v1.2/v1.3

## x728-v2.0.sh
setup scripts for x728 v2.0 only

## User manual
Firstly please select your x728 version.
>sudo bash x728-v2.0.sh

> or

>sudo bash x728-v1.0.sh

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

For the x728 old shell script, you also run this command to remove it, then re-install the x728 script.

## How to software turn off pi 4
> x728off  # type this command will execute software shut down.


