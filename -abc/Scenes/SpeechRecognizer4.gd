class_name SpeechRecognizer4
extends Node

signal word_recognized(word: String)
signal poem_progress_changed(progress: float)

const POEM_VARIANTS: Dictionary = {

	# ===== GRANDILOCUENTES =====

	"absoluto": [
		"absoluto", "absoluto,", "absoluto."
	],

	"eterno": [
		"eterno", "eterno,", "h eterno"
	],

	"eternidad": [
		"eternidad", "eternidat", "eternidad,"
	],

	"inconmensurable": [
		"inconmensurable", "incomensurable", "inconmensurable,"
	],

	"insondable": [
		"insondable", "insondable,", "insondavle"
	],

	"indescifrable": [
		"indescifrable", "indesifrable", "indescifrable,"
	],

	"indefinible": [
		"indefinible", "indefinible,", "indefinivle"
	],

	"omnipresente": [
		"omnipresente", "omnipresente,", "onmipresente"
	],

	"omnipotente": [
		"omnipotente", "onmipotente", "omnipotente,"
	],

	"trascendente": [
		"trascendente", "tracendente", "trascendente,"
	],

	"primordial": [
		"primordial", "primordial,", "primordíal"
	],

	"originario": [
		"originario", "orijinario", "originario,"
	],

	"ancestral": [
		"ancestral", "ancestral,", "ansestral"
	],

	"arcano": [
		"arcano", "arcano,", "arkano"
	],

	"cosmico": [
		"cosmico", "cósmico", "cosmico,"
	],

	"cosmogonico": [
		"cosmogonico", "cosmogónico", "cosmogonico,"
	],

	"universal": [
		"universal", "unibersal", "universal,"
	],

	"planetario": [
		"planetario", "planetario,", "planeta rio"
	],

	"astral": [
		"astral", "astral,", "hastral"
	],

	"celestial": [
		"celestial", "selestial", "celestial,"
	],

	"sidereo": [
		"sidereo", "sidéreo", "sidereo,"
	],

	"estelar": [
		"estelar", "estelar,", "hestelar"
	],

	"galactico": [
		"galactico", "galáctico", "galactico,"
	],

	"interminable": [
		"interminable", "interminable,", "interminavle"
	],

	"inagotable": [
		"inagotable", "inagotable,", "inagotavle"
	],

	"ilimitado": [
		"ilimitado", "ilimitado,", "hilimitado"
	],

	"perpetuo": [
		"perpetuo", "perpetuo,", "perpetua"
	],

	"supremo": [
		"supremo", "supremo,", "suprremo"
	],

	"sublime": [
		"sublime", "sublime,", "suvlime"
	],

	"magnifico": [
		"magnifico", "magnífico", "magnifico,"
	],

	"colosal": [
		"colosal", "colosal,", "colozal"
	],

	"monumental": [
		"monumental", "monumental,", "monumenttal"
	],

	"gigantesco": [
		"gigantesco", "jigantesco", "gigantesco,"
	],

	"descomunal": [
		"descomunal", "descomunal,", "dezcomunal"
	],

	"titánico": [
		"titanico", "titánico", "titanico,"
	],

	"ciclópeo": [
		"ciclopeo", "ciclópeo", "ciclopeo,"
	],

	"abismal": [
		"abismal", "abismal,", "avismal"
	],

	"oceánico": [
		"oceanico", "oceánico", "oceanico,"
	],

	"inefable": [
		"inefable", "inefable,", "inefavle"
	],

	"metafisico": [
		"metafisico", "metafísico", "metafisico,"
	],

	"ontologico": [
		"ontologico", "ontológico", "ontologico,"
	],

	"numinoso": [
		"numinoso", "numinozo", "numinoso,"
	],

	"sacrosanto": [
		"sacrosanto", "sacro santo", "sacrosanto,"
	],

	"milenario": [
		"milenario", "milenario,", "millenario"
	],

	"imperecedero": [
		"imperecedero", "imperecedero,", "imperecedéro"
	],

	"inmortal": [
		"inmortal", "inmortal,", "hinmortal"
	],

	"incorruptible": [
		"incorruptible", "incorruptivle", "incorruptible,"
	],

	"inigualable": [
		"inigualable", "inigualable,", "hinigualable"
	],

	"inenarrable": [
		"inenarrable", "inenarable", "inenarrable,"
	],

	"irreductible": [
		"irreductible", "ireductible", "irreductible,"
	],

	"inalcanzable": [
		"inalcanzable", "inalcansable", "inalcanzable,"
	],

	"inabarcable": [
		"inabarcable", "inabarcable", "inabarcable,"
	],

	"indestructible": [
		"indestructible", "indestructivle", "indestructible,"
	],

	"inevitable": [
		"inevitable", "inevitable,", "hinevitable"
	],

	"fundamental": [
		"fundamental", "fundamental,", "fundametal"
	],

	"esencial": [
		"esencial", "esensial", "esencial,"
	],

	"primigenio": [
		"primigenio", "primijenio", "primigenio,"
	]
}

const WHISPER_PATH: String = "C:/Users/viznu/OneDrive/Documents/Projects/-abc/-abc/whisper/whisper-stream.exe"
const MODEL_PATH: String = "C:/Users/viznu/OneDrive/Documents/Projects/-abc/-abc/whisper/ggml-base.bin"
const OUTPUT_PATH: String = "C:/Users/viznu/AppData/Roaming/Godot/app_userdata/-abc/stream_out.txt"

var recognized_words: Array = []
var _pid: int = -1
var _last_read_pos: int = 0


func _ready():
	print("Ruta del archivo: ", OUTPUT_PATH)
	start_whisper_stream()


func start_whisper_stream():
	# Limpia el archivo
	var clear = FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if clear:
		clear.close()

	_last_read_pos = 0

	var script = "C:\\Users\\viznu\\OneDrive\\Documents\\Projects\\-abc\\-abc\\whisper\\capture.py"

	_pid = OS.create_process(
		"C:\\Python313\\python.exe",
		[script]
	)

	if _pid == -1:
		push_error("No se pudo iniciar capture.py")
	else:
		print("Captura iniciada con PID: ", _pid)

	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_check_output)
	timer.autostart = true
	add_child(timer)


func _check_output():
	if not FileAccess.file_exists(OUTPUT_PATH):
		return

	var file = FileAccess.open(OUTPUT_PATH, FileAccess.READ)
	if file == null:
		return

	file.seek(_last_read_pos)

	var new_text := ""

	while not file.eof_reached():
		var line = file.get_line().strip_edges()

		if line == "":
			continue

		if (
			line.begins_with("[")
			or line.begins_with("whisper")
			or line.begins_with("init")
			or line.begins_with("SDL")
			or line.begins_with("ggml")
			or line.begins_with("main")
		):
			continue

		new_text += line + " "

	_last_read_pos = file.get_position()
	file.close()

	new_text = new_text.strip_edges().to_lower()

	if new_text == "":
		return

	print("Stream recibido: ", new_text)
	process_transcript(new_text)


func process_transcript(transcript: String):
	check_word(transcript)

	var words = transcript.split(" ")

	for word in words:
		var w = normalize(word.strip_edges())

		if w == "" or w.length() <= 1:
			continue

		if (
			w.begins_with("whisper")
			or w.begins_with("main")
			or w.begins_with("init")
			or w.begins_with("error")
			or w.begins_with("[")
		):
			continue

		word_recognized.emit(w)
		check_word(w)


func check_word(word: String):

	word = normalize(word)

	for poem_word in POEM_VARIANTS.keys():

		var variants: Array = POEM_VARIANTS[poem_word]

		for variant in variants:

			if words_are_similar(word, normalize(variant)):

				# impedir repetir palabras ya usadas
				if recognized_words.has(poem_word):
					return

				recognized_words.append(poem_word)

				var progress: float = float(recognized_words.size()) / 9.0
				progress = min(progress, 1.0)

				poem_progress_changed.emit(progress)

				print(
					"Reconocida: ",
					poem_word,
					" (",
					recognized_words.size(),
					"/9)"
				)

				if progress >= 1.0:
					print("===================")
					print("POEMA COMPLETADO")
					print("===================")

				return

func words_are_similar(a: String, b: String) -> bool:
	if a == b:
		return true

	if a.contains(b) or b.contains(a):
		return true

	if b.length() <= 3:
		return a == b

	if abs(a.length() - b.length()) > 2:
		return false

	return levenshtein(a, b) <= 1


func levenshtein(a: String, b: String) -> int:
	var la = a.length()
	var lb = b.length()

	var dp: Array = []

	for i in range(la + 1):
		dp.append([])
		for j in range(lb + 1):
			dp[i].append(0)

	for i in range(la + 1):
		dp[i][0] = i

	for j in range(lb + 1):
		dp[0][j] = j

	for i in range(1, la + 1):
		for j in range(1, lb + 1):
			if a[i - 1] == b[j - 1]:
				dp[i][j] = dp[i - 1][j - 1]
			else:
				dp[i][j] = 1 + mini(
					dp[i - 1][j],
					mini(
						dp[i][j - 1],
						dp[i - 1][j - 1]
					)
				)

	return dp[la][lb]


func normalize(word: String) -> String:
	var w = word.to_lower()

	w = w.replace("á", "a")
	w = w.replace("é", "e")
	w = w.replace("í", "i")
	w = w.replace("ó", "o")
	w = w.replace("ú", "u")

	w = w.replace(",", "")
	w = w.replace(".", "")
	w = w.replace("!", "")
	w = w.replace("?", "")
	w = w.replace("¡", "")
	w = w.replace("¿", "")

	return w


func reset():
	recognized_words.clear()
	poem_progress_changed.emit(0.0)


func _exit_tree():
	if _pid != -1:
		OS.kill(_pid)
