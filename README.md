# TM1640
Driver for TM1640 LED driver chip as used in TTGO Expression Panel Blue LED Display Board

This is an LED driver chip that can drive a grid of LEDs in an 8x16 configuration.
The same chip is used for seven-segment displays, but this driver is not
oriented towards that usage.

The display is treated as a very small screen with the usual screen
update features from the toit-pixel-display library.

The bus is I2C-like, using a clock and data line.  Since it is not
actually I2C we don't use the I2C library, but use bit-banging from Toit.
