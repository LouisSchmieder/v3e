module shader

pub type ShaderFunction = fn ([]voidptr) voidptr

pub enum ShaderType {
	vertex_shader
	fragment_shader
}

pub struct Shader {
pub:
	function ShaderFunction
	typ      ShaderType
pub mut:
	data []voidptr
}

pub fn create_shader(function ShaderFunction, typ ShaderType, init_data voidptr) &Shader {
	return &Shader{
		function: function
		typ: typ
		data: []voidptr{len: 1, init: init_data}
	}
}

pub fn (mut shader Shader) add_attribute(data voidptr) int {
	shader.data << data
	return shader.data.len - 1
}

pub fn (mut shader Shader) run() voidptr {
	return shader.function(shader.data)
}
