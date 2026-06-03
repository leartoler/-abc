extends Node2D

@onready var recognizer: SpeechRecognizer = $SpeechRecognizer
@onready var clouds: Array = []

func _ready():
	clouds = [$Cloud1, $Cloud2, $Cloud3]

	# Centrado en pantalla de 1152x648
	$Cloud1.position = Vector2(50, 150)
	$Cloud1.clear_at_progress = 0.25

	$Cloud2.position = Vector2(400, 250)
	$Cloud2.clear_at_progress = 0.60

	$Cloud3.position = Vector2(650, 180)
	$Cloud3.clear_at_progress = 1.0

	recognizer.poem_progress_changed.connect(_on_progress)
	recognizer.word_recognized.connect(func(w): print("Escuche: ", w))

func _on_progress(progress: float):
	for cloud in clouds:
		cloud.update_from_progress(progress)
	if progress >= 1.0:
		print("Poema completo!")
