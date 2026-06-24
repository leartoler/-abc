shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float time = 0.0;

void fragment()
{
	vec2 p = UV - 0.9;

	float angle =
		atan(p.y,p.x);

	float radius =
		length(p);

	float lines =
		fract(
			radius * 80.0 -
			time * 2.0
		);

	lines =
		smoothstep(
			0.98,
			1.0,
			lines
		);

	vec3 color =
		vec3(0.7,0.9,1.0) *
		lines /
		(radius + 0.05);

	ALBEDO = color;
	ALPHA = length(color);
}