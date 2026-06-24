extends Node

@onready var logo: TextureRect = $"../Logo"
@onready var fondo: ColorRect = $"../Fondo"

@export var next_scene: String = "res://Scenes/Scene_1.tscn"
@export var fade_duration: float = 3.0
@export var wait_time: float = 3.0
@export var color_inicial: Color = Color(0.337, 0.451, 0.212, 1.0)
@export var color_final: Color = Color(0.353, 0.368, 0.249, 1.0)

func _ready():
	logo.modulate.a = 2.0
	fondo.color = color_inicial
	await get_tree().create_timer(wait_time).timeout
	fade_out()

func fade_out():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(logo, "modulate:a", 0.0, fade_duration)
	tween.parallel().tween_property(fondo, "color", color_final, fade_duration)
	tween.tween_callback(go_to_next)

func go_to_next():
	get_tree().change_scene_to_file(next_scene)
