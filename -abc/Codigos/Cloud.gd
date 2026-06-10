class_name Cloud
extends ColorRect

@export var clear_at_progress: float = 0.5
@export var clear_duration: float = 3.0
@export var cloud_color: Color = Color(0.9, 0.95, 1.0, 0.85)

var _clearing: bool = false
var _shader_material: ShaderMaterial
var _time: float = 0.0

func _ready():
	size = Vector2(700, 350)
	pivot_offset = size / 2.0
	color = Color(0, 0, 0, 0)
	
	_shader_material = ShaderMaterial.new()
	_shader_material.shader = _create_shader()
	_shader_material.set_shader_parameter("cloud_color", Color(0.95, 0.97, 1.0, 1.0))
	_shader_material.set_shader_parameter("alpha", 1.0)
	_shader_material.set_shader_parameter("time", 0.0)
	material = _shader_material

func _create_shader() -> Shader:
	var shader = Shader.new()
	shader.code = """
shader_type canvas_item;

uniform vec4 cloud_color : source_color = vec4(0.9, 0.95, 1.0, 1.0);
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float time = 0.0;

vec3 permute(vec3 x) {
	return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float snoise(vec2 v) {
	const vec4 C = vec4(0.211324865405187, 0.366025403784439,
		-0.577350269189626, 0.024390243902439);
	vec2 i  = floor(v + dot(v, C.yy));
	vec2 x0 = v - i + dot(i, C.xx);
	vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;
	i = mod(i, 289.0);
	vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
		+ i.x + vec3(0.0, i1.x, 1.0));
	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
		dot(x12.zw, x12.zw)), 0.0);
	m = m * m * m * m;
	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;
	m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
	vec3 g;
	g.x  = a0.x * x0.x + h.x * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	return 130.0 * dot(m, g);
}

float fbm(vec2 p, int octaves) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	for (int i = 0; i < octaves; i++) {
		value += amplitude * snoise(p * frequency);
		frequency *= 2.0;
		amplitude *= 0.5;
	}
	return value;
}

// Genera estrellas pequeñas
float stars(vec2 uv, float density) {
	vec2 grid = fract(uv * density) - 0.5;
	vec2 id = floor(uv * density);
	float rand = fract(sin(dot(id, vec2(127.1, 311.7))) * 43758.5453);
	float size = 0.004 + rand * 0.006;
	float twinkle = 0.6 + 0.4 * sin(time * (2.0 + rand * 3.0) + rand * 6.28);
	return smoothstep(size, 0.0, length(grid)) * twinkle * step(0.85, rand);
}

void fragment() {
	vec2 uv = UV - 0.5;
	float t = time * 0.05;

	// Distorsión base — movimiento lento y orgánico
	vec2 warp = vec2(
		fbm(uv * 1.5 + vec2(t, t * 0.6), 4),
		fbm(uv * 1.5 + vec2(-t * 0.7, t * 0.4) + vec2(5.2, 1.3), 4)
	) * 0.4;

	vec2 warped = uv + warp;

	// Nebulosa principal — varias capas de ruido
	float n1 = fbm(warped * 2.0 + vec2(t * 0.5, 0.0), 6);
	float n2 = fbm(warped * 3.5 + vec2(0.0, t * 0.3) + vec2(1.7, 9.2), 5);
	float n3 = fbm(warped * 1.2 + vec2(-t * 0.2, t * 0.4) + vec2(3.3, 2.8), 4);

	float nebula = n1 * 0.5 + n2 * 0.3 + n3 * 0.2;

	// Borde difuso sin forma fija — se expande y contrae
	float breathe = 0.05 * sin(time * 0.4);
	float dist = length(uv * vec2(0.9, 1.3));
	float edge = smoothstep(0.6 + breathe, 0.0, dist + nebula * 0.15);

	// Densidad de la nebulosa
	float density = smoothstep(-0.1, 0.5, nebula) * edge;
	density = clamp(density, 0.0, 1.0);

	// ---- Paleta de colores cósmica ----
	// Azul profundo del espacio
	vec3 deep_space = vec3(0.02, 0.01, 0.08);
	// Azul eléctrico
	vec3 electric_blue = vec3(0.1, 0.3, 0.9);
	// Violeta nebulosa
	vec3 nebula_violet = vec3(0.45, 0.1, 0.7);
	// Rosa cósmico
	vec3 cosmic_pink = vec3(0.85, 0.2, 0.55);
	// Naranja cálido — centros de energía
	vec3 energy_orange = vec3(0.95, 0.5, 0.1);
	// Blanco brillante — núcleo
	vec3 core_white = vec3(1.0, 0.95, 0.85);

	// Mezcla de colores según la densidad y el ruido
	float c1 = smoothstep(0.0, 0.3, density);
	float c2 = smoothstep(0.2, 0.5, density);
	float c3 = smoothstep(0.4, 0.7, density);
	float c4 = smoothstep(0.6, 0.9, density);

	// Color base según posición y ruido
	float hue_shift = fbm(uv * 2.0 + vec2(t * 0.3, -t * 0.2), 3) * 0.5 + 0.5;
	vec3 color = deep_space;
	color = mix(color, electric_blue, c1);
	color = mix(color, nebula_violet, c2 * (0.5 + 0.5 * hue_shift));
	color = mix(color, cosmic_pink, c2 * (0.5 - 0.5 * hue_shift + 0.3));
	color = mix(color, energy_orange, c3 * smoothstep(0.3, 0.7, n2));
	color = mix(color, core_white, c4);

	// Filamentos brillantes — líneas de energía
	float filament = pow(abs(snoise(warped * 6.0 + vec2(t, -t * 0.5))), 3.0) * 0.6;
	color += vec3(0.4, 0.6, 1.0) * filament * density;

	// Brillo del núcleo
	float core = pow(density, 3.0) * (1.0 + 0.3 * sin(time * 1.5));
	color += core_white * core * 0.5;

	// Estrellas en las zonas más transparentes
	float star_mask = 1.0 - smoothstep(0.1, 0.5, density);
	float star1 = stars(UV * 3.0, 12.0) * star_mask;
	float star2 = stars(UV * 3.0 + vec2(0.5, 0.3), 18.0) * star_mask;
	color += vec3(0.9, 0.95, 1.0) * (star1 + star2) * 0.8;

	// Opacidad — la nebulosa es más transparente en los bordes
	float final_alpha = density * alpha;

	// Pequeño halo exterior
	float halo = smoothstep(0.65, 0.3, dist) * 0.15 * alpha;
	color += electric_blue * halo;
	final_alpha = max(final_alpha, halo * smoothstep(0.65, 0.5, dist));

	COLOR = vec4(color, final_alpha);
}
"""
	return shader

func _process(delta: float):
	_time += delta
	if _shader_material:
		_shader_material.set_shader_parameter("time", _time)

func update_from_progress(progress: float):
	if progress >= clear_at_progress and not _clearing:
		_clearing = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_method(_set_alpha, cloud_color.a, 0.0, clear_duration)

func _set_alpha(value: float):
	if _shader_material:
		_shader_material.set_shader_parameter("alpha", value)

func reset():
	_clearing = false
	if _shader_material:
		_shader_material.set_shader_parameter("alpha", cloud_color.a)
