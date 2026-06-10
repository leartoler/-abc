extends Node

# Configuración individual de cada cuadro
const CUADROS_CONFIG: Array = [
	{
		"escena": "res://Scenes/Scene_1.tscn",
		"texto": "Momento",
		"imagen": "res://Imagenes/Button_1.png",
		"font_size": 32,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/Scene_2.tscn",
		"texto": "Camino",
		"imagen": "res://Imagenes/Button_2.png",
		"font_size": 32,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/Scene_3.tscn",
		"texto": "Tiempo",
		"imagen": "res://Imagenes/Button_3.png",
		"font_size": 32,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/Scene_4.tscn",
		"texto": "Ser",
		"imagen": "res://Imagenes/Button_4.png",
		"font_size": 32,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/Scene_5.tscn",
		"texto": "Somos",
		"imagen": "res://Imagenes/Button_5.png",
		"font_size": 32,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	}
]

const FUENTE: String = "res://Fuente/Peignot.ttf"

@onready var video: VideoStreamPlayer = $"VideoPlayer"
var _overlay: ColorRect
var _font: FontFile

func _ready():
	_cargar_fuente()
	_setup_video()
	_setup_cuadros()
	_entrada_con_fade()

func _cargar_fuente():
	_font = FontFile.new()
	_font.load_dynamic_font(FUENTE)

func _setup_video():
	video.play()
	video.finished.connect(func():
		video.play()
	)

func _setup_cuadros():
	var posiciones = [
		Vector2(60, 80),
		Vector2(60, 380),
		Vector2(880, 80),
		Vector2(880, 380),
		Vector2(480, 250)
	]
	var tam = Vector2(150, 200)

	for i in range(CUADROS_CONFIG.size()):
		var config = CUADROS_CONFIG[i]
		var cuadro: TextureButton = get_node("Cuadros/Cuadro" + str(i + 1))
		var label: Label = get_node("Etiquetas/Label" + str(i + 1))

		# Posición
		cuadro.position = posiciones[i]
		cuadro.size = tam

		# Imagen del cuadro
		var tex = load(config["imagen"])
		if tex:
			cuadro.texture_normal = tex

		# Texto individual con su propio tamaño y color
		label.text = config["texto"]
		label.position = Vector2(posiciones[i].x, posiciones[i].y + tam.y + 10)
		label.size = Vector2(tam.x, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", _font)
		label.add_theme_font_size_override("font_size", config["font_size"])
		label.add_theme_color_override("font_color", config["color"])

		# Interacción
		var idx = i
		cuadro.pressed.connect(func(): _ir_a_escena(idx))
		cuadro.mouse_entered.connect(func(): _hover_enter(cuadro))
		cuadro.mouse_exited.connect(func(): _hover_exit(cuadro))

func _hover_enter(cuadro: TextureButton):
	var tween = create_tween()
	tween.tween_property(cuadro, "modulate", Color(1.3, 1.3, 1.3, 1.0), 0.2)

func _hover_exit(cuadro: TextureButton):
	var tween = create_tween()
	tween.tween_property(cuadro, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func _ir_a_escena(idx: int):
	_overlay = ColorRect.new()
	_overlay.name = "TransitionOverlay"
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.size = get_viewport().size

	get_tree().root.add_child(_overlay)

	var tween = create_tween()
	tween.tween_property(_overlay, "color:a", 1.0, 0.8)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(CUADROS_CONFIG[idx]["escena"])
	)

func _entrada_con_fade():
	_overlay = ColorRect.new()
	_overlay.color = Color(0.0, 0.0, 0.0, 1.0)
	_overlay.size = get_viewport().size
	_overlay.z_index = 100
	add_child(_overlay)

	await get_tree().create_timer(0.1).timeout
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(_overlay, "color:a", 0.0, 2.0)
	tween.tween_callback(func(): _overlay.queue_free())
