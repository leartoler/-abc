shader_type spatial;
render_mode unshaded, blend_add, cull_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float time = 0.0;

float hash(vec2 p)
{
	return fract(
		sin(dot(p, vec2(127.1,311.7)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 uv = UV - 0.5;

	float d = length(uv);

	float pulse =
		0.75 +
		0.8 *
		sin(
			time +
			d * 15.0
		);

	vec3 color =
		mix(
			vec3(0.7, 0.0, 1.0),
			vec3(0.1, 0.1, 2.0),
			pulse
		);

	float alpha =
		max(0.0, 1.4 - d)
		* (1.0 - progress)
		* pulse;

	alpha = clamp(alpha, 0.0, 1.0);

	ALBEDO = color;
	ALPHA = alpha;
}