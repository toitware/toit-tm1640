// Copyright (C) 2023 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import font show Font
import font_clock.three_by_eight

import gpio

import pixel_display show *
import pixel_display.two_color show *
import tm1640 show Tm1640

main:
  driver := Tm1640
    --sck = gpio.Pin 3
    --sda = gpio.Pin 1

  display := PixelDisplay.two-color --inverted driver

  driver.set_brightness 100

  display.background = BLACK

  font := Font [three_by_eight.ASCII,
                three_by_eight.LATIN_1_SUPPLEMENT]

  style := Style --color=WHITE --font=font

  time := Label --style=style --x=-1 --y=7 --text="!\"#\$%&/~ .,:;-+° @ [] () {} Error 0123456789 abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ .,:;-+°"
  display.add time

  x := 16
  while true:
    time.move_to x 7
    x--
    display.draw
    sleep --ms=200
