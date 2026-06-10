shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled;

uniform vec4 fog_color : source_color = vec4(0.85, 0.9, 1.0, 1.0);
uniform float density = 1.0;
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

	for(int i = 0; i < 6; i++)
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

	float t = time * 0.05;

	float n1 =
		fbm(
			uv * 2.0 +
			vec2(t, 0.0)
		);

	float n2 =
		fbm(
			uv * 4.0 +
			vec2(-t * 0.6, t * 0.2)
		);

	float fog =
		n1 * 0.7 +
		n2 * 0.3;

	fog = smoothstep(
		0.35,
		0.75,
		fog
	);

	vec2 centered = uv - 0.5;

	float edge =
		smoothstep(
			0.75,
			0.25,
			length(centered)
		);

	float alpha =
		fog *
		edge *
		density;

	ALBEDO = fog_color.rgb;
	ALPHA = alpha;
}