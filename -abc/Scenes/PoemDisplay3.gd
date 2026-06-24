class_name PoemDisplay3
extends RichTextLabel

var _verbs := [
	"______",
	"______",
]

var _al := false
var _para := false
var _me := false
var _pensar := false
var _cosas := false
var _en := false
var _el := false
var _como := false
var _contemplar := false
var _abismo := false
var _de := false
var _nuestra := false
var _existencia := false
var _un := false

func _ready():

	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	size = Vector2(1200, 300)
	position = Vector2(50, 400)

	_update_display()


func reveal_word(word: String):

	match word:

		"al":
			_al = true

		"para":
			_para = true

		"me":
			_me = true
			
		"pensar":
			_pensar = true

		"cosas":
			_cosas = true

		"en":
			_en = true
		"el":
			_el = true

		"como":
			_como = true

		"contemplar":
			_contemplar = true
			
		"abismo":
			_abismo = true
			
		"de":
			_de = true
			
		"nuestra":
			_nuestra = true
			
		"existecia":
			_existencia = true
			
		"un":
			_un = true

		_:
			for i in range(_verbs.size()):

				if _verbs[i] == "______":

					_verbs[i] = word
					break

	_update_display()


func _show_word(word:String, revealed:bool) -> String:

	if revealed:
		return "[color=#FFFFFF][font_size=64]" + word + "[/font_size][/color]"

	return "[color=#00000000][font_size=64]" + word + "[/font_size][/color]"


func _show_verb(index:int) -> String:

	if _verbs[index] != "______":

		return (
			"[color=#ed9f00][font_size=64]"
			+ _verbs[index]
			+ "[/font_size][/color]"
		)

	return (
		"[color=b53933][font_size=64]"
		+ "______"
		+ "[/font_size][/color]"
	)


func _update_display():

	var result := ""

	# PENSAR COSAS EN EL TIANGUIS
	result += _show_word("pensar", _pensar)
	result += "     "
	result += _show_word("cosas", _cosas)
	result += "     "
	result += _show_word("en", _en)
	result += "     "
	result += _show_word("el", _el)
	result += "     "
	result += _show_verb(0) # LUGAR A (tianguis)

	result += "\n"

	# COMO CONTEMPLAR EL ABISMO DE NUESTRA EXISTENCIA EN EL PANTEÓN
	result += _show_word("como", _como)
	result += "     "
	result += _show_word("contemplar", _contemplar)
	result += "     "
	result += _show_word("el", _el)
	result += "     "
	result += _show_word("abismo", _abismo)
	result += "     "
	result += _show_word("de", _de)
	result += "     "
	result += _show_word("nuestra", _nuestra)
	result += "     "
	result += _show_word("existencia", _existencia)
	result += "     "
	result += _show_word("en", _en)
	result += "     "
	result += _show_verb(1) # LUGAR B (panteón)

	text = result
