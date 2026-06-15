shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress = 0.0;

float rand(vec2 p)
{
	return fract(
		sin(dot(p, vec2(12.9898,78.233)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 pixel =
		floor(UV * 50.0)
		/ 50.0;

	float r =
		rand(pixel);

	float visible =
		step(
			progress,
			r
		);

	vec3 color =
		mix(
			vec3(0.0,0.0,0.2),
			vec3(0.8,0.4,1.0),
			r
		);

	ALBEDO = color;
	ALPHA = visible;
}