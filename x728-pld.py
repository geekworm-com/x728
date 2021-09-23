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
