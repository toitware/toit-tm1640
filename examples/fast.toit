// Copyright (C) 2023 Toitware ApS.
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

  x := 0

  text := Label --style=style --x=x --y=7
  display.add text

  while true:
    sleep --ms=2000
    ["How", "fast", "can", "you", "read", "this", "text", ""].do: | word |
      text.text = word
      width := font.pixel-width word
      text.x = 7 - (width >> 1)
      display.draw
      sleep --ms=120
