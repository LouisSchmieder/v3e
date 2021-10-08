import shader as s
import color as c

fn test_shader() {
	color := c.create_color(0.3, 0.7, 0.23, 1)
	mut shader := s.create_shader(frag_shader, .fragment_shader, &color)
	res := *(&c.Color(shader.run()))
	assert color == res
}

fn frag_shader(m []voidptr) voidptr {
	return m[0]
}
