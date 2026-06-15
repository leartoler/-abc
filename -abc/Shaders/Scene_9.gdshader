shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress = 0.0;
uniform float time = 0.0;

float rand(vec2 p)
{
	return fract(
		sin(dot(p, vec2(12.9898,78.233)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 cell =
		floor(UV * 80.0);

	float r =
		rand(cell);

	vec2 offset =
		vec2(
			sin(time + r * 20.0),
			cos(time + r * 20.0)
		)
		*
		progress
		*
		0.1;

	float visible =
		step(
			progress,
			r
		);

	ALBEDO =
		vec3(
			0.8,
			0.9,
			1.0
		);

	ALPHA = visible;
}
