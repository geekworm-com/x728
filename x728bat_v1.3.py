#!/usr/bin/env python
# 12th May. 2021 by Harry;
# IMPORTANT!!!IMPORTANT!!!IMPORTANT!!!
# 1. This is low voltage automatic shutdown script only to the X728 series (V1.1, V1.3, V1.5 version, BUT DON'T support future V2.0 version), and it will help you to implement the software automatic shutdown function when the battery is low voltage.
# 2. Once this script is installed. Please charge your batteries when battery low. otherwsie, Your Raspberry Pi cannot boot up again.
# 3. If you have some questions, please contact to: support@geekworm.com
import struct
import smbus
import sys
import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(13, GPIO.OUT)
GPIO.setwarnings(False)

def readVoltage(bus):

     address = 0x36
     read = bus.read_word_data(address, 2)
     swapped = struct.unpack("<H", struct.pack(">H", read))[0]
     voltage = swapped * 1.25 /1000/16
     return voltage


def readCapacity(bus):

     address = 0x36
     read = bus.read_word_data(address, 4)
     swapped = struct.unpack("<H", struct.pack(">H", read))[0]
     capacity = swapped/256
     return capacity


bus = smbus.SMBus(1)

while True:

 print "******************"
 print "Voltage:%5.2fV" % readVoltage(bus)

 print "Battery:%5i%%" % readCapacity(bus)

 if readCapacity(bus) == 100:

         print "Battery FULL"

 if readCapacity(bus) < 20:

         print "Battery Low"

#Set battery low voltage to shut down, you can modify the 3.00 to other value
 if readVoltage(bus) < 3.00:

         print "Battery LOW!!!"
         print "Shutdown in 10 seconds"
         time.sleep(10)
         GPIO.output(13, GPIO.HIGH)
         time.sleep(3)
         GPIO.output(13, GPIO.LOW)

 time.sleep(2)
