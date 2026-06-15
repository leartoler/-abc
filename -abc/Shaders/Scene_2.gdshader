shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float time = 0.0;

float hash(vec2 p)
{
	return fract(
		sin(dot(p, vec2(127.1, 311.7)))
		* 43758.5453123
	);
}

float noise(vec2 p)
{
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x)
		+ (c - a) * u.y * (1.0 - u.x)
		+ (d - b) * u.x * u.y;
}

float fbm(vec2 p)
{
	float value = 0.0;
	float amp = 0.5;

	for(int i = 0; i < 8; i++)
	{
		value += noise(p) * amp;
		p *= 2.0;
		amp *= 0.5;
	}

	return value;
}

void fragment()
{
	vec2 uv = UV;

	float n =
		fbm(
			uv * 12.0 +
			vec2(time * 0.03, 0.0)
		);

	float fog =
		smoothstep(
			0.3,
			0.8,
			n
		);

	vec2 centered = uv - 0.5;

	float edge =
		smoothstep(
			0.8,
			0.2,
			length(centered)
		);

	float alpha =
		fog *
		edge *
		(1.0 - progress);

	ALBEDO =
		vec3(
			0.8,
			0.85,
			1.0
		);

	ALPHA = alpha;
}