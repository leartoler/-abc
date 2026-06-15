shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress = 0.0;

float rand(vec2 p)
{
	return fract(
		sin(dot(p, vec2(127.1,311.7)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 uv =
		floor(UV * 20.0)
		/ 20.0;

	float n =
		rand(uv);

	float shadow =
		step(
			progress,
			n
		);

	ALBEDO =
		vec3(0.05);

	ALPHA =
		shadow;
}
