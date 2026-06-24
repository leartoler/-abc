extends Node2D

@onready var fog_mesh = $SubViewport/Node3D/MeshInstance3D
@onready var recognizer: SpeechRecognizer3 = $SpeechRecognizer
@onready var poem_display: PoemDisplay3 = $PoemLabel
@onready var instruction_label: Label = $InstructionLabel
@onready var spoken_word_label = $SpokenWordLabel
@onready var spoken_word_bg = $SpokenWordBg
@onready var spoken_word_start_pos = $SpokenWordLabel.position
@onready var return_button = $ReturnButton

@export var bg_color: Color = Color(0, 0, 0, 0.5)

#Cambiar por el numero de palabras
var palabras_correctas := 0
const PALABRAS_OBJETIVO := 10
##################333

func mostrar_instruccion(texto: String):
	instruction_label.text = texto
	var posicion_inicial = instruction_label.position
	instruction_label.visible = true
	instruction_label.modulate.a = 0.0
	instruction_label.position = posicion_inicial + Vector2(0, 20)

	var tween = create_tween()
	tween.parallel().tween_property(
		instruction_label,
		"modulate:a",
		1.0,  #de 0 a 1
		2.0  #tiempo
	)

	tween.parallel().tween_property(
		instruction_label,
		"position",
		posicion_inicial,
		15 #posición inicial
	)

	tween.tween_interval(20.0) #tiempo en que permanece quieto
	tween.parallel().tween_property(
		instruction_label,
		"modulate:a",
		0.0,
		15.0 #tiempo
	)

	tween.parallel().tween_property(
		instruction_label,
		"position",
		posicion_inicial + Vector2(0, -40),
		15.0 #tiempo en desaparecer
	)


func _ready():
	spoken_word_bg.z_index = 99 #BG
	spoken_word_label.z_index = 100 #BG	
	return_button.pressed.connect(_on_return_button_pressed)	
	$TextureRect.texture = $SubViewport.get_texture()	
	spoken_word_label.z_index = 100
	poem_display.z_index = 50
	instruction_label.z_index = 60
	return_button.z_index = 200
	var overlay = get_tree().root.get_node_or_null("TransitionOverlay")

	if overlay:
		var tween = create_tween()
		tween.tween_property(overlay, "color:a", 0.0, 1.5)
		tween.finished.connect(func():
			overlay.queue_free()
		)
	recognizer.poem_progress_changed.connect(_on_progress)	
	recognizer.word_recognized.connect(
	func(w):
		print("Escuche: ", w)
		show_spoken_word(w)
)	
	#mostrar_instruccion("Siento al caminar, camino para perderme,\nme pierdo para descubrirme \n \nCambia los verbos por cualquier verbo, que comience con una vocal \ny que te interpele, en tiempo infinitivo.")

func show_spoken_word(word: String):
	spoken_word_label.position = spoken_word_start_pos
	spoken_word_label.text = word
	spoken_word_label.visible = true
	spoken_word_label.modulate.a = 1.0
	spoken_word_label.scale = Vector2(1.5, 1.5)

	# Ajustar el fondo al tamaño del texto
	var padding = Vector2(20, 10)
	var text_size = spoken_word_label.get_theme_font("font").get_string_size(
		word,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		spoken_word_label.get_theme_font_size("font_size")
	)
	spoken_word_bg.size = text_size + padding
	spoken_word_bg.position = spoken_word_start_pos - padding / 2
	spoken_word_bg.visible = true
	spoken_word_bg.modulate.a = 1.0
	spoken_word_bg.color = bg_color

	var tween = create_tween()
	tween.parallel().tween_property(spoken_word_label, "position", spoken_word_start_pos + Vector2(0, -40), 5)
	tween.parallel().tween_property(spoken_word_label, "modulate:a", 0.0, 5)
	tween.parallel().tween_property(spoken_word_label, "scale", Vector2(1.0, 1.0), 4)
	# Animar el fondo junto con el label
	tween.parallel().tween_property(spoken_word_bg, "position:y", spoken_word_bg.position.y - 40, 5)
	tween.parallel().tween_property(spoken_word_bg, "modulate:a", 0.0, 5)

	tween.finished.connect(
		func():
			spoken_word_label.visible = false
			spoken_word_bg.visible = false
			spoken_word_label.position = spoken_word_start_pos
			spoken_word_label.scale = Vector2(1.0, 1.0)
	)
	
	#############
func registrar_palabra_correcta():

	palabras_correctas += 1

	var progress = float(palabras_correctas) / PALABRAS_OBJETIVO

	fog_mesh.set_progress(progress)

	print("Progreso: ", progress)

	if palabras_correctas >= PALABRAS_OBJETIVO:

		print("Poema completo!")

		return_button.visible = true

		fog_mesh.set_progress(1.0)
	
	

func _on_progress(progress: float):

	if recognizer.recognized_words.is_empty():
		return

	var last_word = recognizer.recognized_words.back()

	poem_display.reveal_word(last_word)

	fog_mesh.set_progress(progress)

	print("Progreso: ", progress)

	if progress >= 1.0:

		print("Poema completo!")

		return_button.visible = true

		fog_mesh.set_progress(1.0)

func _on_return_button_pressed():
	get_tree().change_scene_to_file(
		"res://Scenes/MenuScene.tscn"
	)
	
	#quitar esto al final
func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_spoken_word("probar")
		registrar_palabra_correcta()
