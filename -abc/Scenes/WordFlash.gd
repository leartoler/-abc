extends Label

const FUENTE: String = "res://Fuente/Peignot.ttf"
const DURACION: float = 1.5  # segundos que se ve la palabra

var _tween: Tween

func _ready():
	# Tipografía
	var font = FontFile.new()
	font.load_dynamic_font(FUENTE)
	add_theme_font_override("font", font)
	add_theme_font_size_override("font_size", 48)
	add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.0))

	# Centrado en pantalla
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	size = Vector2(800, 100)
	anchors_preset = Control.PRESET_CENTER
	pivot_offset = size / 2.0

func mostrar_palabra(palabra: String):
	# Cancela animación anterior si hay una
	if _tween:
		_tween.kill()

	text = palabra
	modulate.a = 0.0

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_SINE)

	# Aparece rápido
	_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	# Se queda visible
	_tween.tween_interval(DURACION)
	# Desaparece suave
	_tween.tween_property(self, "modulate:a", 0.0, 0.6)
