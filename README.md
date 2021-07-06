This shell script and python file is tested only on Raspberry pi OS..

We refactored the script file of X728, hope it will be easier to use

Guide: https://wiki.geekworm.com/X728-Software

## x728-v1.0.sh
setup scripts for x728 v1.2/v1.3

## x728-v2.0.sh
setup scripts for x728 v2.0 only

## User manual
> Enable I2C
```
 sudo raspi-config
 ```
 Select `Interface Opitions` then 'ENTER', select `I2C`, then 'ENTER'
 ```
 sudo reboot
```

> Install necessary software (python and i2c tool library)
```
sudo apt-get install python-smbus
sudo apt-get install i2c-tools
```

> Download x728 setup scripts:
```
git clone https://github.com/geekworm-com/x728
cd x728
chmod +x *.sh
```

> Install script&reboot:
Firstly please select your x728 version.

```
sudo bash x728-v1.0.sh
sudo reboot
```

or
```
sudo bash x728-v2.0.sh
sudo reboot
```

> Test safe shutdown
 ```
x728off
```
- x728off is safe shutdown command
- press on-board blue button `1-2` seconds to reboot
- press on-board blue button `3` seconds to safe shutdown,
- press on-board blue button `7-8` seconds to force shutdown.

You can get the following python file in /home/pi/ fold:
- x728bat.py # Reading battery voltage
- x728pld.py # Testing AC power off/loss or power adapter failure detection

> How to reading battery voltage and percentage, this is the sample code, you can modify it by your request.
```
 python /home/pi/x728bat.py &
```
Or use another method:
But we hope that the script can be executed automatically when the Raspberry Pi board boots, we can use crontab system command to achieve it. please refer to the following:
```
pi@raspberrypi ~ $  `sudo crontab -e`
```
 Choose "`1`" then press Enter

 Add a line at the end of the file that reads like this:
```
`@reboot python /home/pi/x728bat.py`
```
> Testing AC power off/loss or power adapter failure detection (need to short the 'PLD' pin)
```
sudo python x728pld.py
```
## uninstall_x728.sh
uninsatll x728 shell script, run the following command:
> sudo ./uninstall_x728.sh

For the x728 old shell script, you also run this command to remove it, then re-install the x728 script.


