module color

import math

pub struct Color {
pub mut:
	r f32
	g f32
	b f32
	a f32
}

pub fn create_color(r f32, g f32, b f32, a f32) Color {
	return Color{
		r: r
		g: g
		b: b
		a: a
	}
}

pub fn (a Color) + (b Color) Color {
	mut r := a.r + b.r
	mut g := a.g + b.g
	mut bl := a.b + b.b
	mut al := a.a + b.a
	return Color{
		r: if r > 1 { 1 } else { r }
		g: if g > 1 { 1 } else { g }
		b: if bl > 1 { 1 } else { bl }
		a: if al > 1 { 1 } else { al }
	}
}

pub fn (a Color) - (b Color) Color {
	mut r := a.r - b.r
	mut g := a.g - b.g
	mut bl := a.b - b.b
	mut al := a.a - b.a
	return Color{
		r: if r < 0 { 0 } else { r }
		g: if g < 0 { 0 } else { g }
		b: if bl < 0 { 0 } else { bl }
		a: if al < 0 { 0 } else { al }
	}
}

pub fn (a Color) * (b Color) Color {
	return Color{
		r: a.r * b.r
		g: a.g * b.g
		b: a.b * b.b
		a: a.a * b.a
	}
}

pub fn (a Color) / (b Color) Color {
	return Color{
		r: a.r / b.r
		g: a.g / b.g
		b: a.b / b.b
		a: a.a / b.a
	}
}
