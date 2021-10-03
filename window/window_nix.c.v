module window

import math

#pkgconfig x11
#include <X11/Xlib.h>

[typedef]
struct C.Display {}

[typedef]
struct C.Window {}

[typedef]
struct C.XEvent {
	@type int
}

[typedef]
struct C.GC {}

[typedef]
struct C.XPoint {
	x u16
	y u16
}

fn C.XOpenDisplay(voidptr) &C.Display
fn C.DefaultScreen(&C.Display) int
fn C.XCreateSimpleWindow(&C.Display, C.Window, int, int, u32, u32, u32, u64, u64) C.Window
fn C.XRootWindow(&C.Display, int) C.Window
fn C.XCloseDisplay(&C.Display)
fn C.XMapWindow(&C.Display, C.Window)
fn C.XSelectInput(&C.Display, C.Window, u64)
fn C.XNextEvent(&C.Display, &C.XEvent)
fn C.BlackPixel(&C.Display, int) u64
fn C.WhitePixel(&C.Display, int) u64
fn C.DefaultGC(&C.Display, int) C.GC

// Draw
fn C.XClearWindow(&C.Display, C.Window)
fn C.XDrawLine(&C.Display, C.Window, C.GC, int, int, int, int)
fn C.XDrawPoints(&C.Display, C.Window, C.GC, &C.XPoint, int, int)

struct Display {
	d &C.Display = 0
}

pub struct Window {
mut:
	d      &Display = 0
	w      C.Window
	screen int
pub mut:
	width   int
	height  int
	running bool
	buffer  &WindowPixelBuffer = &WindowPixelBuffer{}
}

pub fn create_window(cfg WindowConfig) ?&Window {
	mut win := &Window{}
	win.d = open_display() ?
	win.screen = cfg.screen
	if cfg.screen == -1 {
		win.screen = C.DefaultScreen(win.d.d)
	}
	win.height = cfg.height
	win.width = cfg.width
	win.w = C.XCreateSimpleWindow(win.d.d, C.XRootWindow(win.d.d, win.screen), cfg.x,
		cfg.y, cfg.width, cfg.height, cfg.depth, C.BlackPixel(win.d.d, win.screen), C.WhitePixel(win.d.d,
		win.screen))
	win.buffer.pixels = []u32{len: win.height * win.width}
	C.XSelectInput(win.d.d, win.w, C.ExposureMask | C.KeyPressMask)
	C.XMapWindow(win.d.d, win.w)
	return win
}

pub fn (mut window Window) run() {
	for window.running {
		C.XClearWindow(window.d.d, window.w)
		mut points := []C.XPoint{}
		for i, pixel in window.buffer.pixels {
			y := math.floor(i / window.width)
			x := i % window.width
			if pixel != 0b00000000 {
				points << C.XPoint{
					x: u16(x)
					y: u16(y)
				}
			}
		}
		if points.len == 0 {
			continue
		}
		C.XDrawPoints(window.d.d, window.w, C.DefaultGC(window.d.d, window.screen), points.data,
			points.len, C.CoordModeOrigin)
	}
	C.XCloseDisplay(window.d.d)
}

pub fn (mut window Window) input() {
	mut event := &C.XEvent{}
	for true {
		C.XNextEvent(window.d.d, event)
		if event.@type == C.KeyPress {
			break
		}
	}
	window.running = false
}

fn open_display() ?&Display {
	display := C.XOpenDisplay(voidptr(0))
	if display == voidptr(0) {
		return error('Cannot open display')
	}
	return &Display{display}
}
