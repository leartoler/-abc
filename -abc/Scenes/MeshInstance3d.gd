extends MeshInstance3D

var shader_time := 0.0

func _process(delta):
	shader_time += delta

	material_override.set_shader_parameter(
		"time",
		shader_time
	)
