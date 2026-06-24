class_name PoemDisplay5
extends RichTextLabel

var _nombre := "______"

var _eres := false
var _lo := false
var _que := false
var _somos := false
var _nunca := false
var _preguntes := false
var _por := false
var _quien := false
var _se := false
var _marchitan := false
var _las := false
var _flores := false


func _ready():

	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	size = Vector2(1200, 400)
	position = Vector2(50, 300)

	_update_display()


func reveal_word(word:String):

	match word:

		"eres":
			_eres = true

		"lo":
			_lo = true

		"que":
			_que = true

		"somos":
			_somos = true

		"nunca":
			_nunca = true

		"preguntes":
			_preguntes = true

		"por":
			_por = true

		"quien":
			_quien = true

		"se":
			_se = true

		"marchitan":
			_marchitan = true

		"las":
			_las = true

		"flores":
			_flores = true

		_:
			if _nombre == "______":
				_nombre = word

	_update_display()


func _show_word(word:String, revealed:bool) -> String:

	if revealed:
		return (
			"[color=#FFFFFF][font_size=64]"
			+ word +
			"[/font_size][/color]"
		)

	return (
		"[color=#00000000][font_size=64]"
		+ word +
		"[/font_size][/color]"
	)


func _show_name() -> String:

	if _nombre != "______":
		return (
			"[color=#5a2e4b][font_size=64]"
			+ _nombre +
			"[/font_size][/color]"
		)

	return (
		"[bgcolor=#d9653b][font_size=64]"
		+ "                "
		+ "[/font_size][/bgcolor]"
	)


func _update_display():

	var result := ""

	# ERES LO QUE SOMOS
	result += _show_word("eres", _eres)
	result += " "
	result += _show_word("lo", _lo)
	result += " "
	result += _show_word("que", _que)
	result += " "
	result += _show_word("somos", _somos)

	result += ",\n"

	# SOMOS LO QUE ERES
	result += _show_word("somos", _somos)
	result += " "
	result += _show_word("lo", _lo)
	result += " "
	result += _show_word("que", _que)
	result += " "
	result += _show_word("eres", _eres)

	result += ".\n"

	# NUNCA PREGUNTES POR QUIEN
	result += _show_word("nunca", _nunca)
	result += " "
	result += _show_word("preguntes", _preguntes)
	result += " "
	result += _show_word("por", _por)
	result += " "
	result += _show_word("quien", _quien)

	result += "\n"

	# SE MARCHITAN LAS FLORES
	result += _show_word("se", _se)
	result += " "
	result += _show_word("marchitan", _marchitan)
	result += " "
	result += _show_word("las", _las)
	result += " "
	result += _show_word("flores", _flores)

	result += ";\n"

	# SE MARCHITAN POR NOMBRE
	result += _show_word("se", _se)
	result += " "
	result += _show_word("marchitan", _marchitan)
	result += " "
	result += _show_word("por", _por)
	result += " "
	result += _show_name()

	result += "."

	text = result
