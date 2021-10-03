module window

pub struct WindowConfig {
pub:
	screen int = -1
	width int
	height int
	x u32
	y u32
	depth u32
}

pub struct Screen {
pub mut:
	width u32
	height u32
}

pub struct WindowPixelBuffer {
pub mut:
	pixels []u32
}