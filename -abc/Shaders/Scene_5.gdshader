shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float time = 0.0;
uniform vec3 star_color : source_color = vec3(1.0, 1.0, 1.0);

float rand(vec2 p)
{
	return fract(
		sin(dot(p, vec2(12.9898,78.233)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 uv = UV * 200.0;
	vec2 id = floor(uv);

	float r = rand(id);

	float visible = step(progress, r);

	vec2 gv = fract(uv) - 0.5;

	float star = smoothstep(
		0.9,
		0.0,
		length(gv)
	);

	float twinkle =
		0.5 +
		0.5 *
		sin(time * 3.0 + r * 10.0);

	float v =
		star *
		visible *
		twinkle;

	ALBEDO = star_color * v;
	ALPHA = v;
}