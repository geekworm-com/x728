#X728 RTC setting up
sudo sed -i '$ i rtc-ds1307' /etc/modules
sudo sed -i '$ i echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device' /etc/rc.local
sudo sed -i '$ i hwclock -s' /etc/rc.local
sudo sed -i '$ i #x728 Start power management on boot' /etc/rc.local

#x728 Powering on /reboot /full shutdown through hardware
#!/bin/bash

#sudo sed -e '/shutdown/ s/^#*/#/' -i /etc/rc.local

echo '#!/bin/bash

SHUTDOWN=5
REBOOTPULSEMINIMUM=200
REBOOTPULSEMAXIMUM=600
echo "$SHUTDOWN" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio$SHUTDOWN/direction
BOOT=12
echo "$BOOT" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$BOOT/direction
echo "1" > /sys/class/gpio/gpio$BOOT/value

echo "X728 Shutting down..."

while [ 1 ]; do
  shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
  if [ $shutdownSignal = 0 ]; then
    /bin/sleep 0.2
  else
    pulseStart=$(date +%s%N | cut -b1-13)
    while [ $shutdownSignal = 1 ]; do
      /bin/sleep 0.02
      if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAXIMUM ]; then
        echo "X728 Shutting down", SHUTDOWN, ", halting Rpi ..."
        sudo poweroff
        exit
      fi
      shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
    done
    if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMINIMUM ]; then
      echo "X728 Rebooting", SHUTDOWN, ", recycling Rpi ..."
      sudo reboot
      exit
    fi
  fi
done' > /etc/x728pwr.sh
sudo chmod +x /etc/x728pwr.sh
sudo sed -i '$ i /etc/x728pwr.sh &' /etc/rc.local

#X728 full shutdown through Software
#!/bin/bash

sudo sed -e '/button/ s/^#*/#/' -i /etc/rc.local

echo '#!/bin/bash

BUTTON=26

echo "$BUTTON" > /sys/class/gpio/export;
echo "out" > /sys/class/gpio/gpio$BUTTON/direction
echo "1" > /sys/class/gpio/gpio$BUTTON/value

SLEEP=${1:-4}

re='^[0-9\.]+$'
if ! [[ $SLEEP =~ $re ]] ; then
   echo "error: sleep time not a number" >&2; exit 1
fi

echo "X728 Shutting down..."
/bin/sleep $SLEEP

#restore GPIO 26
echo "0" > /sys/class/gpio/gpio$BUTTON/value
' > /usr/local/bin/x728softsd.sh
sudo chmod +x /usr/local/bin/x728softsd.sh
sudo echo "alias x728off='sudo x728softsd.sh'" >> /home/pi/.bashrc

#X728 Battery voltage & precentage reading
#!/bin/bash

#Get current PYTHON verson, 2 or 3
#PY_VERSION=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1}'`

echo '#!/usr/bin/env python
import struct
import smbus
import sys
import time
import RPi.GPIO as GPIO

# Global settings
# GPIO is 26 for x728 v2.0 v2.1 v2.2, GPIO is 13 for X728 v1.2/v1.3
GPIO_PORT 	= 26
I2C_ADDR    = 0x36

GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_PORT, GPIO.OUT)
GPIO.setwarnings(False)

def readVoltage(bus):

     address = I2C_ADDR
     read = bus.read_word_data(address, 2)
     swapped = struct.unpack("<H", struct.pack(">H", read))[0]
     voltage = swapped * 1.25 /1000/16
     return voltage

def readCapacity(bus):

     address = I2C_ADDR
     read = bus.read_word_data(address, 4)
     swapped = struct.unpack("<H", struct.pack(">H", read))[0]
     capacity = swapped/256
     return capacity

bus = smbus.SMBus(1) # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

while True:
 print ("******************")
 print ("Voltage:%5.2fV" % readVoltage(bus))
 print ("Battery:%5i%%" % readCapacity(bus))

 if readCapacity(bus) == 100:
        print ("Battery FULL")
 if readCapacity(bus) < 20:
        print ("Battery Low")

#Set battery low voltage to shut down, you can modify the 3.00 to other value
 if readVoltage(bus) < 3.00:
        print ("Battery LOW!!!")
        print ("Shutdown in 10 seconds")
        time.sleep(10)
        GPIO.output(GPIO_PORT, GPIO.HIGH)
        time.sleep(3)
        GPIO.output(GPIO_PORT, GPIO.LOW)

 time.sleep(2)
' >> /home/pi/x728bat.py
#sudo chmod +x /home/pi/x728bat.py

#X728 AC Power loss / power adapter failture detection
#!/bin/bash
echo '#!/usr/bin/env python
import RPi.GPIO as GPIO
import time

PLD_PIN = 6
BUZZER_PIN = 20
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(PLD_PIN, GPIO.IN)
GPIO.setup(BUZZER_PIN, GPIO.OUT)

while True:
    i = GPIO.input(PLD_PIN)
    if i == 0:
        print("AC Power OK")
        GPIO.output(BUZZER_PIN, 0)
    elif i == 1:
        print("Power Supply A/C Lost")
        GPIO.output(BUZZER_PIN, 1)
        time.sleep(0.1)
        GPIO.output(BUZZER_PIN, 0)
        time.sleep(0.1)

    time.sleep(1)
' > /home/pi/x728pld.py
#sudo chmod +x /home/pi/x728pld.py

# x728 Test Auto shutdown when AC power loss or power adapter failure
echo '#!/usr/bin/env python
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(6, GPIO.IN)
GPIO.setup(26, GPIO.OUT)
GPIO.setwarnings(False)

def my_callback(channel):
    if GPIO.input(6):     # if port 6 == 1
        print ("---AC Power Loss OR Power Adapter Failure---")
        print ("Shutdown in 5 seconds")
        time.sleep(5)
        GPIO.output(26, GPIO.HIGH)
        time.sleep(3)
        GPIO.output(26, GPIO.LOW)

#time.sleep(2)

    else:                  # if port 6 != 1
        print ("---AC Power OK,Power Adapter OK---")

GPIO.add_event_detect(6, GPIO.BOTH, callback=my_callback)
input("Testing Started")
' > /home/pi/x728plsd.py
