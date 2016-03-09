#!/usr/bin/python
# Example using a character LCD connected to a Raspberry Pi or BeagleBone Black.
import time

import zerorpc

import Adafruit_CharLCD as LCD


# Raspberry Pi pin configuration:
# This uses pin labels not pin positions
lcd_rs        = 22  # Note this might need to be changed to 21 for older revision Pi's.
lcd_en        = 5
lcd_d4        = 6
lcd_d5        = 13
lcd_d6        = 19
lcd_d7        = 26
lcd_backlight = 4 # Unused

# BeagleBone Black configuration:
# lcd_rs        = 'P8_8'
# lcd_en        = 'P8_10'
# lcd_d4        = 'P8_18'
# lcd_d5        = 'P8_16'
# lcd_d6        = 'P8_14'
# lcd_d7        = 'P8_12'
# lcd_backlight = 'P8_7'

# Define LCD column and row size for 16x2 LCD.
lcd_columns = 16
lcd_rows    = 2

# Alternatively specify a 20x4 LCD.
# lcd_columns = 20
# lcd_rows    = 4

# Initialize the LCD using the pins above.
lcd = LCD.Adafruit_CharLCD(lcd_rs, lcd_en, lcd_d4, lcd_d5, lcd_d6, lcd_d7,
                            lcd_columns, lcd_rows, lcd_backlight)

# Print a two line message
lcd.message('ZeroRPC\nReady!')

class pylcd(object):
    def hello(self, name):
        return "Hello, %s" % name

    def clear( self, nothing ):
        lcd.clear()
        return True

    def message( self, message ):
        lcd.clear()
        lcd.message( message )
        return True

    def show_cursor( self, bool ):
        lcd.show_cursor( bool )
        return True

    def blink( self, bool ):
        lcd.blink( bool )
        return True

    def move_right( self, nothing ):
        lcd.move_right()
        return True

    def move_right( self, nothing ):
        lcd.move_left()
        return True

s = zerorpc.Server(pylcd())
s.bind("tcp://0.0.0.0:4242")
s.run()
