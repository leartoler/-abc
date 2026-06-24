shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec4 petal_color : source_color = vec4(0.62, 0.42, 0.95, 1.0);
uniform vec4 dark_ink : source_color = vec4(0.12, 0.08, 0.25, 1.0);

uniform float density = 180.0;
uniform float speed = 0.25;

float hash(float n)
{
	return fract(sin(n) * 43758.5453123);
}

void fragment()
{
	vec2 uv = UV;

	float alpha = 0.0;

	for (float i = 0.0; i < 180.0; i++)
	{
		float id = i;

		// base position
		float x = hash(id * 1.73);

		// depth layer (fake accumulation depth)
		float z = hash(id * 6.11);

		// speed variation
		float s = speed + hash(id * 3.21) * 0.5;

		float t = TIME * s + hash(id * 8.17);

		// strict downward motion
		float y = 1.2 - mod(t, 2.2);

		if (y < -0.3)
			y += 2.2;

		// wind (Hokusai-style strong lateral flow)
		float wind =
			sin(t * 1.2 + id * 12.0) * 0.12 +
			sin(t * 0.5 + id * 3.0) * 0.08;

		// slight swirl like ukiyo-e water/air flow
		wind += sin(uv.y * 6.0 + TIME) * 0.03;

		// perspective compression (gives depth layering)
		float depth_scale = mix(1.3, 0.5, z);

		vec2 p = uv - vec2(x + wind * depth_scale, y);

		// elongated petal shape (jacaranda / ukiyo-e brush stroke feel)
		p.x *= 1.6;
		p.y *= 0.7;

		float d = length(p);

		// softer ink-like petals
		float petal =
			smoothstep(0.06, 0.0, d);

		// STRONGER rotation (key change)
		float rot = sin(t * 4.0 + id * 10.0);

		petal *= smoothstep(0.2, 1.0, abs(rot));

		// ink depth variation
		float ink_depth = mix(1.0, 0.4, z);

		alpha += petal * ink_depth;
	}

	alpha = clamp(alpha, 0.0, 1.0);

	// "acumulación visual":
	// más densidad percibida en capas bajas (como suelo lleno de flores)
	float accumulation = smoothstep(1.0, 0.0, uv.y);

	alpha *= (1.2 - accumulation * 0.6);

	// fade with poem
	alpha *= (1.0 - progress);

	// ukiyo-e color grading (less neon, more ink)
	vec3 color =
		mix(
			dark_ink.rgb,
			petal_color.rgb,
			0.7
		);

	ALBEDO = color;
	ALPHA = alpha;
}