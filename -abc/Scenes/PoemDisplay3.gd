class_name PoemDisplay3
extends RichTextLabel

var _nouns := [
	"______", # vida
	"______", # lágrimas
	"______", # lluvia
]

var _toda := false
var _tu := false
var _vida := false

var _lo := false
var _que := false
var _has := false
var _visto := false
var _y := false
var _sentido := false

var _todo := false
var _se := false
var _perdera := false

var _como := false
var _lagrimas := false
var _arrastradas := false

var _por := false
var _la := false
var _lluvia := false


func _ready():

	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	size = Vector2(1200, 500)
	position = Vector2(50, 250)

	_update_display()


func reveal_word(word: String):

	word = word.to_lower()

	match word:

		"toda":
			_toda = true

		"tu":
			_tu = true

		"vida":
			_vida = true

		"lo":
			_lo = true

		"que":
			_que = true

		"has":
			_has = true

		"visto":
			_visto = true

		"y":
			_y = true

		"sentido":
			_sentido = true

		"todo":
			_todo = true

		"se":
			_se = true

		"perdera", "perderá":
			_perdera = true

		"como":
			_como = true

		"lagrimas", "lágrimas":
			_lagrimas = true

		"arrastradas":
			_arrastradas = true

		"por":
			_por = true

		"la":
			_la = true

		"lluvia":
			_lluvia = true

		_:
			for i in range(_nouns.size()):

				if _nouns[i] == "______":

					_nouns[i] = word
					break

	_update_display()


func _show_word(word:String, revealed:bool) -> String:

	if revealed:
		return "[color=#FFFFFF][font_size=64]" + word + "[/font_size][/color]"

	return "[color=#00000000][font_size=64]" + word + "[/font_size][/color]"


func _show_noun(index:int) -> String:

	if _nouns[index] != "______":

		return (
			"[color=#996d92][font_size=64]"
			+ _nouns[index]
			+ "[/font_size][/color]"
		)

	return (
		"[bgcolor=#bde5f2][font_size=64]"
		+ "        "
		+ "[/font_size][/bgcolor]"
	)


func _update_display():

	var result := ""

	# Toda tu VIDA,
	result += _show_word("Toda", _toda)
	result += " "
	result += _show_word("tu", _tu)
	result += " "
	result += _show_noun(0)
	result += ","

	result += "\n"

	# lo que has visto y sentido,
	result += _show_word("lo", _lo)
	result += " "
	result += _show_word("que", _que)
	result += " "
	result += _show_word("has", _has)
	result += " "
	result += _show_word("visto", _visto)
	result += " "
	result += _show_word("y", _y)
	result += " "
	result += _show_word("sentido", _sentido)
	result += ","

	result += "\n"

	# todo se perderá,
	result += _show_word("todo", _todo)
	result += " "
	result += _show_word("se", _se)
	result += " "
	result += _show_word("perderá", _perdera)
	result += ","

	result += "\n"

	# como LÁGRIMAS arrastradas
	result += _show_word("como", _como)
	result += " "
	result += _show_noun(1)
	result += " "
	result += _show_word("arrastradas", _arrastradas)

	result += "\n"

	# por la LLUVIA.
	result += _show_word("por", _por)
	result += " "
	result += _show_word("la", _la)
	result += " "
	result += _show_noun(2)
	result += "."

	text = result
