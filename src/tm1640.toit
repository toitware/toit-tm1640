// Copyright (C) 2023 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

/**
Driver for the TM1640 LED driver with an 8x16 LED configuration.
This is an LED driver chip that can drive a grid of LEDs.  The same chip
  is used for seven-segment displays, but this driver is not oriented towards
  that usage.
The display is treated as a very small screen with the usual screen
  update features from the toit-pixel-display library.
The bus is I2C-like, using a clock and data line.
*/

import bitmap show *
import gpio
import pixel_display.two_color show *
import pixel_display show *

TM1640_AUTOINCREMENT_ADDRESS_ ::= 0x40
TM1640_FIXED_ADDRESS_         ::= 0x44

TM1640_SET_ADDRESS_           ::= 0xc0

TM1640_OFF_                   ::= 0x80
TM1640_BRIGHTNESS_            ::= 0x88  // Add 0-7.

/**
Black-and-white driver intended to be used with the Pixel-Display package
  at https://pkg.toit.io/package/pixel_display&url=github.com%2Ftoitware%2Ftoit-pixel-display&index=latest
See https://docs.toit.io/language/sdk/display
*/
class Tm1640 extends AbstractDriver:
  clock_ /gpio.Pin
  data_ /gpio.Pin
  command_buffer_ := ByteArray 1
  data_buffer_ := ByteArray 17

  // Given two GPIO pins for output.
  constructor .clock_ .data_:
    init_

  // Given two GPIO pins for output.
  constructor --sck/gpio.Pin --sda/gpio.Pin:
    return Tm1640 sck sda

  static WIDTH_ ::= 16
  static HEIGHT_ ::= 8

  width/int ::= WIDTH_
  height/int ::= HEIGHT_
  flags/int ::= FLAG_2_COLOR

  init_:
    clock_.configure --output
    data_.configure --output
    clock_.set 1
    data_.set 1

  // 0 switches off the display.
  // 1-100 sets the brightness.  There are only 8 different switched on brightnesses.
  // Takes effect on the next draw.
  set_brightness percent/int -> none:
    if percent == 0:
      command_ TM1640_OFF_
    else:
      command_ TM1640_BRIGHTNESS_ + percent / 13

  command_ byte:
    command_buffer_[0] = byte
    write_ command_buffer_

  off -> none:
    set_brightness 0

  /// Not normally called by users of this package.  Used by the pixel-display library.
  draw_two_color left/int top/int right/int bottom/int pixels/ByteArray -> none:
    command_ TM1640_AUTOINCREMENT_ADDRESS_

    data_buffer_[0] = TM1640_SET_ADDRESS_
    pixels.size.repeat: data_buffer_[it + 1] = pixels[it] ^ 0xff
    write_ data_buffer_

  write_ buffer/ByteArray:
    data_.set 0
    buffer.do: | byte |
      8.repeat:
        bit := byte & 1
        byte >>= 1
        clock_.set 0
        data_.set bit
        clock_.set 1
    data_.set 1
    // Do the end-of-transmission dance that is specific to the
    // TM1640 and prevents the next command from being interpreted
    // as data.
    data_.set 0
    clock_.set 0
    clock_.set 1
    data_.set 1
