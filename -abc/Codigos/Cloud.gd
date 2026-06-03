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
	vec2 i1;
	i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;
	i = mod(i, 289.0);
	vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
		+ i.x + vec3(0.0, i1.x, 1.0));
	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
		dot(x12.zw, x12.zw)), 0.0);
	m = m * m;
	m = m * m;
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

float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	for (int i = 0; i < 5; i++) {
		value += amplitude * snoise(p * frequency);
		frequency *= 2.0;
		amplitude *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 uv = UV - 0.5;
	float t = time * 0.08;

	float n1 = fbm(uv * 2.5 + vec2(t, t * 0.4));
	float n2 = fbm(uv * 4.0 + vec2(-t * 0.6, t * 0.3) + n1 * 0.4);
	float n3 = fbm(uv * 1.5 + vec2(t * 0.2, -t * 0.5) + n2 * 0.3);

	float noise = (n1 * 0.5 + n2 * 0.3 + n3 * 0.2);

	float dist = length(uv * vec2(1.0, 1.6));
	float edge = smoothstep(0.55, 0.05, dist);

	// Sube el umbral para que haya más densidad visible
	float density = smoothstep(-0.3, 0.2, noise) * edge;
	density = clamp(density, 0.0, 1.0);

	vec4 final_color = cloud_color;
	final_color.a = density * alpha;
	COLOR = final_color;
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
