// Copyright (C) 2020 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import font show Font
import font_x11_adobe.sans_06 as sans

import gpio

import pixel_display show *
import pixel_display.two_color show BLACK WHITE
import tm1640 show Tm1640

main:
  driver := Tm1640
    --sck = gpio.Pin 3
    --sda = gpio.Pin 1

  display := PixelDisplay.two-color --inverted driver

  driver.set_brightness 50

  display.background = BLACK

  font := Font [sans.ASCII]

  style := Style --font=font --color=WHITE

  x := 16

  text := Label --style=style --x=x --y=7 --text="Toit for the win!        IoT made easy!"
  display.add text

  while true:
    for x = 16; x > -200; x--:
      text.move_to x 7
      display.draw
      sleep --ms=30
