class_name SpeechRecognizer5
extends Node

signal word_recognized(word: String)
signal poem_progress_changed(progress: float)

const POEM_VARIANTS: Dictionary = {

	# ===== NOMBRES HOMBRE =====

"aaron": ["aaron", "aarón", "aron", "aaron,"],
"abel": ["abel", "abel,", "abel"],
"abraham": ["abraham", "abraham,", "abran"],
"adolfo": ["adolfo", "adolfo,", "adolfo"],
"adrian": ["adrian", "adrián", "adrian,", "adriam"],
"agustin": ["agustin", "agustín", "agustin,"],
"alan": ["alan", "allan", "alan,"],
"alberto": ["alberto", "alberto,", "alverto"],
"alejandro": ["alejandro", "alexandro", "alejandro,"],
"alfonso": ["alfonso", "alfonzo", "alfonso,"],
"alonso": ["alonso", "alonzo", "alonso,"],
"andres": ["andres", "andrés", "andres,"],
"antonio": ["antonio", "toño", "antonio,"],
"armando": ["armando", "armando,", "armando"],
"arturo": ["arturo", "arturo,", "arturo"],
"benjamin": ["benjamin", "benjamín", "benjamin,"],
"brayan": ["brayan", "bryan", "brallan", "brayan,"],
"bruno": ["bruno", "bruno,", "bruno"],
"carlos": ["carlos", "karlos", "carlos,"],
"cesar": ["cesar", "césar", "cesar,"],
"christian": ["christian", "cristian", "christian,"],
"cristian": ["cristian", "christian", "cristian,"],
"daniel": ["daniel", "daniel,", "danel"],
"david": ["david", "davit", "david,"],
"diego": ["diego", "diego,", "diego"],
"eduardo": ["eduardo", "edu", "eduardo,"],
"edgar": ["edgar", "edgar,", "edgardo"],
"emanuel": ["emanuel", "emanuel,", "manuel"],
"emilio": ["emilio", "emilio,", "emilio"],
"enrique": ["enrique", "enrrique", "enrique,"],
"erick": ["erick", "eric", "erick,"],
"ernesto": ["ernesto", "ernesto,", "ernesto"],
"esteban": ["esteban", "esteban,", "esteban"],
"ezequiel": ["ezequiel", "esequiel", "ezequiel,"],
"fabian": ["fabian", "fabián", "fabian,"],
"felipe": ["felipe", "felipe,", "felipe"],
"fernando": ["fernando", "fernando,", "fernado"],
"francisco": ["francisco", "fransisco", "pancho", "francisco,"],
"gabriel": ["gabriel", "gabriel,", "gavriel"],
"gerardo": ["gerardo", "gerardo,", "jerardo"],
"gilberto": ["gilberto", "gilberto,", "gilberto"],
"guillermo": ["guillermo", "gillermo", "guillermo,"],
"hector": ["hector", "héctor", "ector", "hector,"],
"hugo": ["hugo", "hugo,", "ugo"],
"ismael": ["ismael", "ismael,", "ismael"],
"ivan": ["ivan", "iván", "iban", "ivan,"],
"javier": ["javier", "javier,", "xabier"],
"jesus": ["jesus", "jesús", "jesuz", "jesus,"],
"joaquin": ["joaquin", "joaquín", "joaquin,"],
"jonathan": ["jonathan", "jonatan", "jonathan,"],
"jorge": ["jorge", "jorje", "jorge,"],
"jose": ["jose", "josé", "jose,"],
"juan": ["juan", "juam", "juan,"],
"julian": ["julian", "julián", "julian,"],
"julio": ["julio", "yulio", "julio,"],
"kevin": ["kevin", "kevin,", "kevin"],
"leo": ["leo", "leo,", "leo"],
"leonardo": ["leonardo", "leonardo,", "leo"],
"luis": ["luis", "luiz", "luis,"],
"manuel": ["manuel", "manuel,", "manel"],
"marco": ["marco", "marco,", "marko"],
"marcos": ["marcos", "marcos,", "markos"],
"martin": ["martin", "martín", "martin,"],
"mateo": ["mateo", "mateo,", "mateo"],
"mauricio": ["mauricio", "maurisio", "mauricio,"],
"miguel": ["miguel", "migel", "miguel,"],
"nicolas": ["nicolas", "nicolás", "nicolas,"],
"octavio": ["octavio", "octabio", "octavio,"],
"omar": ["omar", "omar,", "homar"],
"oscar": ["oscar", "óscar", "oskar", "oscar,"],
"pablo": ["pablo", "pablo,", "pavlo"],
"pedro": ["pedro", "pedro,", "pedro"],
"rafael": ["rafael", "rafa", "rafael,"],
"raul": ["raul", "raúl", "raul,"],
"ricardo": ["ricardo", "rikardo", "ricardo,"],
"roberto": ["roberto", "beto", "roberto,"],
"rodrigo": ["rodrigo", "rodrigo,", "rodrigo"],
"ruben": ["ruben", "rubén", "ruben,"],
"salvador": ["salvador", "salvador,", "chava"],
"samuel": ["samuel", "samuel,", "samuel"],
"sebastian": ["sebastian", "sebastián", "sebastian,"],
"sergio": ["sergio", "serjio", "sergio,"],
"vicente": ["vicente", "vicente,", "visente"],
"victor": ["victor", "víctor", "victor,"],
"yahir": ["yahir", "yair", "yahir,"],

# ===== NOMBRES MUJER =====

"adriana": ["adriana", "adrianna", "adriana,"],
"alejandra": ["alejandra", "alexandra", "alejandra,"],
"alicia": ["alicia", "alicia,", "alisia"],
"ana": ["ana", "anna", "ana,"],
"andrea": ["andrea", "andrea,", "andrea"],
"angelica": ["angelica", "angélica", "angelica,"],
"barbara": ["barbara", "bárbara", "barbara,"],
"beatriz": ["beatriz", "beatris", "beatriz,"],
"berenice": ["berenice", "berenise", "berenice,"],
"brenda": ["brenda", "brenda,", "brenda"],
"camila": ["camila", "kamila", "camila,"],
"carla": ["carla", "karla", "carla,"],
"carmen": ["carmen", "karmen", "carmen,"],
"carolina": ["carolina", "karolina", "carolina,"],
"cassandra": ["cassandra", "kasandra", "cassandra,"],
"cecilia": ["cecilia", "sesilia", "cecilia,"],
"claudia": ["claudia", "klaudia", "claudia,"],
"dalia": ["dalia", "dalia,", "dalia"],
"daniela": ["daniela", "dany", "daniela,"],
"diana": ["diana", "diana,", "diana"],
"elena": ["elena", "elena,", "helena"],
"elizabeth": ["elizabeth", "elisabeth", "elizabeth,"],
"erika": ["erika", "ericka", "erika,"],
"esmeralda": ["esmeralda", "esmeralda,", "esmeralda"],
"fatima": ["fatima", "fátima", "fatima,"],
"fernanda": ["fernanda", "fer", "fernanda,"],
"gabriela": ["gabriela", "gaby", "gabriela,"],
"gloria": ["gloria", "gloria,", "gloria"],
"guadalupe": ["guadalupe", "lupita", "guada", "guadalupe,"],
"irma": ["irma", "irma,", "irma"],
"jacqueline": ["jacqueline", "jaqueline", "jacqueline,"],
"jimena": ["jimena", "ximena", "jimena,"],
"karina": ["karina", "carina", "karina,"],
"laura": ["laura", "laurra", "laura,"],
"leticia": ["leticia", "leti", "leticia,"],
"lucero": ["lucero", "lucero,", "lucero"],
"lucia": ["lucia", "lucía", "lucia,"],
"luisa": ["luisa", "luisa,", "luisa"],
"maria": ["maria", "maría", "maria,"],
"mariana": ["mariana", "marianna", "mariana,"],
"marisol": ["marisol", "marisol,", "marisol"],
"mayra": ["mayra", "maira", "mayra,"],
"melissa": ["melissa", "melisa", "melissa,"],
"monica": ["monica", "mónica", "monica,"],
"nancy": ["nancy", "nanci", "nancy,"],
"norma": ["norma", "norma,", "norma"],
"paola": ["paola", "pao", "paola,"],
"patricia": ["patricia", "paty", "patricia,"],
"paulina": ["paulina", "paulina,", "paulina"],
"regina": ["regina", "rejina", "regina,"],
"renata": ["renata", "rena", "renata,"],
"rosa": ["rosa", "rossa", "rosa,"],
"sandra": ["sandra", "sandra,", "sandra"],
"sara": ["sara", "zahra", "sara,"],
"silvia": ["silvia", "silbia", "silvia,"],
"sofia": ["sofia", "sofía", "sofia,"],
"teresa": ["teresa", "tere", "teresa,"],
"valentina": ["valentina", "valentina,", "vale"],
"valeria": ["valeria", "baleria", "valeria,"],
"vanessa": ["vanessa", "banessa", "vanessa,"],
"veronica": ["veronica", "verónica", "vero", "veronica,"],
"victoria": ["victoria", "victoria,", "vicky"],
"virginia": ["virginia", "virjinia", "virginia,"],
"ximena": ["ximena", "jimena", "ximena,"],
"yolanda": ["yolanda", "yolanda,", "yolanda"],
"yuliana": ["yuliana", "juliana", "yuliana,"]
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
