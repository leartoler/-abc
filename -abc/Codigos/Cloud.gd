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

uniform vec4 sky_color : source_color = vec4(0.53, 0.81, 0.98, 1.0);
uniform vec4 cloud_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float speed = 0.02;
uniform float scale = 4.0;
uniform float cloud_density = 0.55;

float random(vec2 st){
    return fract(sin(dot(st.xy,
        vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise(vec2 st){
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0,0.0));
    float c = random(i + vec2(0.0,1.0));
    float d = random(i + vec2(1.0,1.0));

    vec2 u = f*f*(3.0-2.0*f);

    return mix(a,b,u.x)
        + (c-a)*u.y*(1.0-u.x)
        + (d-b)*u.x*u.y;
}

float fbm(vec2 st){
    float value = 0.0;
    float amplitude = 0.5;

    for(int i = 0; i < 4; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

void fragment(){

    vec2 uv = UV;

    uv.x += TIME * speed;

    vec2 p = uv * scale;

    float n = fbm(p);

    float clouds = smoothstep(
        cloud_density,
        cloud_density + 0.08,
        n
    );

    vec3 col = mix(
        sky_color.rgb,
        cloud_color.rgb,
        clouds
    );

    COLOR = vec4(col, 1.0);
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
