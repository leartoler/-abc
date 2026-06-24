class_name PoemDisplay4
extends RichTextLabel

var _palabras := [
	"______", # infinito
	"______", # enorme
	"______", # inmenso
	"______"  # efímero
]

var _vistas := false
var _de := false
var _un := false
var _mar := false

var _jamas := false
var _abarcaras := false
var _lo := false

var _dentro := false
var _ser := false


func _ready():

	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	size = Vector2(1400, 350)
	position = Vector2(50, 320)

	_update_display()


func reveal_word(word: String):

	match word:

		"vistas":
			_vistas = true

		"de":
			_de = true

		"un":
			_un = true

		"mar":
			_mar = true

		"jamas":
			_jamas = true

		"abarcaras":
			_abarcaras = true

		"lo":
			_lo = true

		"dentro":
			_dentro = true

		"ser":
			_ser = true

		_:
			for i in range(_palabras.size()):

				if _palabras[i] == "______":

					_palabras[i] = word
					break

	_update_display()


func _show_word(word:String, revealed:bool) -> String:

	if revealed:
		return "[color=#FFFFFF][font_size=64]" + word + "[/font_size][/color]"

	return "[color=#00000000][font_size=64]" + word + "[/font_size][/color]"


func _show_replace(index:int) -> String:

	if _palabras[index] != "______":

		return (
			"[color=#d8ebf2][font_size=64]"
			+ _palabras[index]
			+ "[/font_size][/color]"
		)

	return (
		"[bgcolor=#496773][font_size=64]"
		+ "             "
		+ "[/font_size][/bgcolor]"
	)


func _update_display():

	var result := ""

	# INFINITAS VISTAS DE UN ENORME MAR

	result += _show_replace(0)
	result += "     "
	result += _show_word("vistas", _vistas)
	result += "     "
	result += _show_word("de", _de)
	result += "     "
	result += _show_word("un", _un)
	result += "     "
	result += _show_replace(1)
	result += "     "
	result += _show_word("mar", _mar)

	result += "\n"

	# JAMÁS ABARCARÁS LO INMENSO

	result += _show_word("jamás", _jamas)
	result += "     "
	result += _show_word("abarcarás", _abarcaras)
	result += "     "
	result += _show_word("lo", _lo)
	result += "     "
	result += _show_replace(2)

	result += "\n"

	# DENTRO DE UN EFÍMERO SER

	result += _show_word("dentro", _dentro)
	result += "     "
	result += _show_word("de", _de)
	result += "     "
	result += _show_word("un", _un)
	result += "     "
	result += _show_replace(3)
	result += "     "
	result += _show_word("ser", _ser)

	text = result
