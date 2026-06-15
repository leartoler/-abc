extends Node2D

@onready var fog_mesh = $SubViewport/Node3D/MeshInstance3D
@onready var recognizer: SpeechRecognizer = $SpeechRecognizer
@onready var poem_display: PoemDisplay = $PoemLabel
@onready var instruction_label: Label = $InstructionLabel
@onready var spoken_word_label = $SpokenWordLabel
@onready var spoken_word_start_pos = $SpokenWordLabel.position


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
		1.5 #posición inicial
	)

	tween.tween_interval(2.0) #tiempo en que permanece quieto
	tween.parallel().tween_property(
		instruction_label,
		"modulate:a",
		0.0,
		4.0 #tiempo
	)

	tween.parallel().tween_property(
		instruction_label,
		"position",
		posicion_inicial + Vector2(0, -40),
		3.0 #tiempo en desaparecer
	)


func _ready():

	$TextureRect.texture = $SubViewport.get_texture()
	spoken_word_label.z_index = 100
	poem_display.z_index = 50
	instruction_label.z_index = 60
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
	
	mostrar_instruccion("Recita el poema en voz alta")

func show_spoken_word(word: String):

	spoken_word_label.position = spoken_word_start_pos

	spoken_word_label.text = word

	spoken_word_label.visible = true

	spoken_word_label.modulate.a = 1.0

	spoken_word_label.scale = Vector2(0.8, 0.8)

	var tween = create_tween()

	tween.parallel().tween_property(
		spoken_word_label,
		"position",
		spoken_word_start_pos + Vector2(0, -40),
		1.5
	)

	tween.parallel().tween_property(
		spoken_word_label,
		"modulate:a",
		0.0,
		1.5
	)

	tween.parallel().tween_property(
		spoken_word_label,
		"scale",
		Vector2(1.0, 1.0),
		0.25
	)

	tween.finished.connect(
		func():
			spoken_word_label.visible = false
			spoken_word_label.position = spoken_word_start_pos
			spoken_word_label.scale = Vector2(1.0, 1.0)
	)

func _on_progress(progress: float):
	var revealed_count = recognizer.recognized_words.size()
	for i in range(revealed_count):
		var word_key = recognizer.POEM_VARIANTS.keys()[i]
		poem_display.reveal_word(word_key)
	fog_mesh.set_progress(progress)
	if progress >= 1.0:
		print("Poema completo!")
