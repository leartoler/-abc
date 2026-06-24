class_name PoemDisplay
extends RichTextLabel

var _verbs := [
	"______",
	"______",
	"______",
	"______",
	"______",
	"______"
]

var _al := false
var _para := false
var _me := false


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
		"[bgcolor=#b53933][font_size=64]"
		+ "        "  # espacios = ancho del rectángulo
		+ "[/font_size][/bgcolor]"
	)


func _update_display():

	var result := ""

	result += _show_verb(0)
	result += "     "
	result += _show_word("al", _al)
	result += "     "
	result += _show_verb(1)

	result += "\n"

	result += _show_verb(2)
	result += "     "
	result += _show_word("para", _para)
	result += "     "
	result += _show_verb(3)

	result += "\n"

	result += _show_word("me", _me)
	result += "     "
	result += _show_verb(4)
	result += "     "
	result += _show_word("para", _para)
	result += "     "
	result += _show_verb(5)

	text = result
