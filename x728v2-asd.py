#!/usr/bin/env python
# We want to automatically shut down when the battery voltage is lower than a certain specified value, is it possible?
# Please run the 'python3 /home/pi/x728/x728v2-asd.py &' to get this function

import struct
import smbus
import sys
import time
import RPi.GPIO as GPIO

GPIO_PORT=26
I2C_ADDR=0x36

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


bus = smbus.SMBus(1)

while True:

 print ("******************")
 print ("Voltage:%5.2fV" % readVoltage(bus))
 print ("Battery:%5i%%" % readCapacity(bus))

 if readCapacity(bus) == 100:
         print ("Battery FULL")

 if readCapacity(bus) < 20:
         print ("Battery Low")

#Set battery low voltage to shut down
 if readVoltage(bus) < 3.00:
         print ("Battery LOW!!!")
         print ("Shutdown in 10 seconds")
         time.sleep(10)
         GPIO.output(GPIO_PORT, GPIO.HIGH)
         time.sleep(3)
         GPIO.output(GPIO_PORT, GPIO.LOW)

 time.sleep(2)


