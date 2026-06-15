extends MeshInstance3D

var shader_time := 0.0

func _process(delta):
	shader_time += delta

	material_override.set_shader_parameter(
		"time",
		shader_time
	)

func set_progress(value: float):
	material_override.set_shader_parameter(
		"progress",
		value
	)
