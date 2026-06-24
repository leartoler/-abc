extends Node

# Configuración individual de cada cuadro
const CUADROS_CONFIG: Array = [
	{
		"escena": "res://Scenes/MenuScene1.tscn",
		"texto": "Momento",
		"imagen": "res://Imagenes/Button_1.png",
		"font_size": 35,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/MenuScene2.tscn",
		"texto": "Camino",
		"imagen": "res://Imagenes/Button_2.png",
		"font_size": 35,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/MenuScene3.tscn",
		"texto": "Tiempo",
		"imagen": "res://Imagenes/Button_3.png",
		"font_size": 35,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/MenuScene4.tscn",
		"texto": "Ser",
		"imagen": "res://Imagenes/Button_4.png",
		"font_size": 35,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	},
	{
		"escena": "res://Scenes/MenuScene5.tscn",
		"texto": "Somos",
		"imagen": "res://Imagenes/Button_5.png",
		"font_size": 35,
		"color": Color(0.0, 0.0, 0.0, 0.902)
	}
]

const FUENTE: String = "res://Fuente/Helvetica-Bold.ttf"

@onready var video: VideoStreamPlayer = $"VideoPlayer"

var _overlay: ColorRect
var _font: FontFile

var cuadros: Array[TextureButton] = []
var tiempo := 0.0

func _ready():

	_cargar_fuente()
	_setup_video()
	_setup_cuadros()
	_entrada_con_fade()

func _process(delta):

	tiempo += delta

	for i in range(cuadros.size()):

		var cuadro = cuadros[i]

		if cuadro.has_meta("hover"):
			continue

		var offset = float(i) * 0.7

		var escala = 1.0 + sin(tiempo * 1.5 + offset) * 0.01

		var y = sin(tiempo + offset) * 5.0

		cuadro.scale = Vector2(escala, escala)

		cuadro.position.y = cuadro.get_meta("base_y") + y

func _cargar_fuente():
	_font = FontFile.new()
	_font.load_dynamic_font(FUENTE)

func _setup_video():

	video.play()

	video.finished.connect(
		func():
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

		var cuadro: TextureButton = get_node(
			"Cuadros/Cuadro" + str(i + 1)
		)

		var label: Label = get_node(
			"Etiquetas/Label" + str(i + 1)
		)

		cuadro.position = posiciones[i]
		cuadro.size = tam

		var tex = load(config["imagen"])

		if tex:
			cuadro.texture_normal = tex

		label.text = config["texto"]

		label.position = Vector2(
			posiciones[i].x,
			posiciones[i].y + tam.y + 10
		)

		label.size = Vector2(tam.x, 50)

		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		label.add_theme_font_override(
			"font",
			_font
		)

		label.add_theme_font_size_override(
			"font_size",
			config["font_size"]
		)

		label.add_theme_color_override(
			"font_color",
			config["color"]
		)

		var idx = i

		cuadro.pressed.connect(
			func():
				_ir_a_escena(idx)
		)

		cuadro.mouse_entered.connect(
			func():
				_hover_enter(cuadro)
		)

		cuadro.mouse_exited.connect(
			func():
				_hover_exit(cuadro)
		)

		cuadros.append(cuadro)

		cuadro.set_meta(
			"base_y",
			posiciones[i].y
		)

func _hover_enter(cuadro: TextureButton):
	cuadro.set_meta("hover", true)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		cuadro,
		"scale",
		Vector2(1.07, 1.07),
		0.25
	)

	tween.tween_property(
		cuadro,
		"position",
		cuadro.position + Vector2(0, -10),
		0.25
	)

	tween.tween_property(
		cuadro,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.25
	)

func _hover_exit(cuadro: TextureButton):

	cuadro.remove_meta("hover")

	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		cuadro,
		"scale",
		Vector2.ONE,
		0.25
	)

	tween.tween_property(
		cuadro,
		"position",
		Vector2(
			cuadro.position.x,
			cuadro.get_meta("base_y")
		),
		0.25
	)

	tween.tween_property(
		cuadro,
		"modulate",
		Color.WHITE,
		0.25
	)

func _ir_a_escena(idx: int):

	_overlay = ColorRect.new()

	_overlay.name = "TransitionOverlay"

	_overlay.color = Color(
		0,
		0,
		0,
		0
	)

	_overlay.size = get_viewport().size

	get_tree().root.add_child(_overlay)

	var tween = create_tween()

	tween.tween_property(
		_overlay,
		"color:a",
		1.0,
		0.8
	)

	tween.finished.connect(
		func():
			get_tree().change_scene_to_file(
				CUADROS_CONFIG[idx]["escena"]
			)
	)

func _entrada_con_fade():

	_overlay = ColorRect.new()

	_overlay.color = Color(
		0.0,
		0.0,
		0.0,
		1.0
	)

	_overlay.size = get_viewport().size

	_overlay.z_index = 100

	add_child(_overlay)

	await get_tree().create_timer(0.1).timeout

	var tween = create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)

	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(
		_overlay,
		"color:a",
		0.0,
		2.0
	)

	tween.tween_callback(
		func():
			_overlay.queue_free()
	)
