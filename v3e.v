module main

import window
import time
import shader

fn main() {
	println('Hello World!')
	mut win := window.create_window(window.WindowConfig{
		width: 600
		height: 400
		x: 100
		y: 100
		depth: 0
	}) or { panic(err) }
	win.running = true
	go win.run()
	go win.input()
	mut buffer := [2]window.WindowPixelBuffer{}
	mut draw_buffer := 0
	mut counter := 100
	for win.running {
		buffer[draw_buffer].pixels = []u32{len: win.width * win.height}
		for i in 0 .. 100 {
			buffer[draw_buffer].pixels[counter * win.width + i] = 1
			buffer[draw_buffer].pixels[(counter + 1) * win.width + i] = 1
		}
		counter += 2
		if counter + 1 > win.height {
			counter = 0
		}

		win.buffer = unsafe { &buffer[draw_buffer] }
		draw_buffer = if draw_buffer == 0 { draw_buffer + 1 } else { 0 }
		time.sleep(time.second / 144)
	}
}
