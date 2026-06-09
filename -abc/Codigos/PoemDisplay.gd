class_name PoemDisplay
extends RichTextLabel

# El poema completo en orden
const POEM_WORDS_ORDER: Array = ["el", "rosa", "mas", "rojo"]
const POEM_DISPLAY: Dictionary = {
	"el": "el",
	"rosa": "rosa",
	"mas": "más",
	"rojo": "rojo"
}

var _revealed_words: Array = []

func _ready():
	# Configuración visual del texto
	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_OFF
	
	# Tamaño y posición centrada
	size = Vector2(800, 200)
	position = Vector2(176, 224)
	
	# Muestra el poema completo pero invisible al inicio
	_update_display()

func reveal_word(word: String):
	if not _revealed_words.has(word):
		_revealed_words.append(word)
		_update_display()

func _update_display():
	var result = ""
	for i in range(POEM_WORDS_ORDER.size()):
		var word = POEM_WORDS_ORDER[i]
		if _revealed_words.has(word):
			result += "[color=#FFFFFF][font_size=64]" + POEM_DISPLAY[word] + "[/font_size][/color]"
		else:
			result += "[color=#00000000][font_size=64]" + POEM_DISPLAY[word] + "[/font_size][/color]"
		
		# Agrega espacio entre palabras excepto la última
		if i < POEM_WORDS_ORDER.size() - 1:
			result += "[font_size=64]   [/font_size]"
	
	text = result
