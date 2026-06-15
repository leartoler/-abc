shader_type spatial;
render_mode unshaded, blend_add, cull_disabled;

uniform float progress = 0.0;
uniform float time = 0.0;

void fragment()
{
	vec2 p =
		UV - 0.5;

	float r =
		length(p);

	float speed =
		5.0 *
		(1.0 - progress);

	float lines =
		fract(
			r * 30.0 -
			time * speed
		);

	lines =
		smoothstep(
			0.95,
			1.0,
			lines
		);

	vec3 color =
		vec3(
			0.7,
			0.9,
			1.0
		)
		*
		lines
		/
		(r + 0.1);

	ALBEDO = color;
	ALPHA = length(color);
}