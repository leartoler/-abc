extends Node

@onready var logo: TextureRect = $"../Logo"
@onready var fondo: ColorRect = $"../Fondo"

const FADE_DURATION: float = 3.0
const NEXT_SCENE: String = "res://Scenes/MainScene.tscn"

func _ready():
	logo.modulate.a = 1.0
	fondo.color = Color(0.0, 0.0, 0.02, 1.0)
	await get_tree().create_timer(1.0).timeout
	fade_out()

func fade_out():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	# Desvanece el logo
	tween.tween_property(logo, "modulate:a", 0.0, FADE_DURATION)
	# Simultáneamente oscurece el fondo a negro total
	tween.parallel().tween_property(fondo, "color", Color(0.0, 0.0, 0.0, 1.0), FADE_DURATION)
	tween.tween_callback(go_to_game)

func go_to_game():
	get_tree().change_scene_to_file(NEXT_SCENE)
