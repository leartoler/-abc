shader_type spatial;
render_mode unshaded, blend_add, cull_disabled;

uniform float progress = 0.0;
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
	vec2 uv =
		UV - 0.5;

	float d =
		length(uv);

	float pulse =
		0.5 +
		0.5 *
		sin(
			time +
			d * 15.0
		);

	float alpha =
		(1.0 - d)
		*
		(1.0 - progress)
		*
		pulse;

	vec3 color =
		mix(
			vec3(0.2,0.0,0.8),
			vec3(1.0,0.2,0.8),
			pulse
		);

	ALBEDO = color;
	ALPHA = alpha;
}
