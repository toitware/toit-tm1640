// Copyright (C) 2020 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import font show Font
import font_clock.three_by_five

import gpio

import pixel_display show *
import pixel_display.texture show *
import pixel_display.two_color show *
import tm1640 show Tm1640

main:
  driver := Tm1640
    gpio.Pin 27
    gpio.Pin 25

  display := TwoColorPixelDisplay driver

  driver.set_brightness 100

  display.background = BLACK

  font := Font [three_by_five.ASCII,
                three_by_five.LATIN_1_SUPPLEMENT]

  context := display.context --inverted --landscape --font=font --color=WHITE

  time := display.text context -1 6 "|0:00"

  pixmap := BitmapTexture 0 0 16 8 context.transform WHITE
  display.add pixmap

  colon := true
  while true:
    now := Time.now.local
    h := now.h > 12 ? now.h - 12 : now.h
    c := colon ? ":" : "  "
    colon = not colon
    time.text = "$(%2d h)$c$(%02d now.m)"
    pixmap.clear_all_pixels
    if now.s < 30:
      pixmap.set_pixel
        now.s / 2 + 1
        7
    else:
      pixmap.set_pixel
        (59 - now.s) / 2 + 1
        7
    display.draw
    sleep --ms=500
