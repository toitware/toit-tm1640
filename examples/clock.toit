// Copyright (C) 2023 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import font show Font
import font_clock.three_by_five

import gpio

import pixel_display show *
import pixel_display.two_color show BLACK WHITE
import tm1640 show Tm1640

main:
  driver := Tm1640
    gpio.Pin 3
    gpio.Pin 1

  display := PixelDisplay.two-color --inverted driver

  driver.set_brightness 100

  display.background = BLACK

  font := Font [three_by_five.ASCII,
                three_by_five.LATIN_1_SUPPLEMENT]

  style := Style --color=WHITE --font=font

  time := Label --style=style --x=-1 --y=6 --text="|0:00"
  display.add time

  bouncing := BouncingPixel --x=0 --y=0 --w=16 --h=8
  display.add bouncing

  colon := true
  while true:
    now := Time.now.local
    h := now.h > 12 ? now.h - 12 : now.h
    c := colon ? ":" : "  "
    colon = not colon
    time.text = "$(%2d h)$c$(%02d now.m)"
    bouncing.seconds = now.s
    display.draw
    sleep --ms=500

/**
A pixel that bounces back and forth on line 7, at a speed of half a pixel per
  second.
*/
class BouncingPixel extends CustomElement:

  seconds_ := 0
  color_/int := WHITE
  
  type -> string: return "bouncing-pixel"

  seconds= value/int -> none:
    if seconds_ != value:
      invalidate
      seconds_ = value

  constructor
      --x/int=0
      --y/int=0
      --w/int=16
      --h/int=8
      --color/int=WHITE
      --style/Style?=null
      --classes/List?=null
      --id/string?=null
      --background=null
      --border/Border?=null:
    color_ = color
    super
        --x = x
        --y = y
        --w = w
        --h = h
        --style = style
        --classes = classes
        --id = id
        --background = background
        --border = border

  // Redraw routine.
  custom-draw canvas/Canvas:
    x := ?
    if seconds_ < 30:
      x = seconds_ / 2 + 1
    else:
      x = (59 - seconds_) / 2 + 1
    canvas.rectangle x 7
      --w = 1
      --h = 1
      --color = color_
