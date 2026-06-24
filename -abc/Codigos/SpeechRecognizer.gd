class_name SpeechRecognizer
extends Node

signal word_recognized(word: String)
signal poem_progress_changed(progress: float)

const POEM_VARIANTS: Dictionary = {

	# ===== PALABRAS FIJAS =====

	"al": [
		"al", "ál", "a", "el", "all", "aal", "adl"
	],

	"para": [
		"para", "pará", "parra", "pa", "para,"
	],

	"me": [
		"me", "mé", "mi", "meh", "m"
	],

	# ===== VERBOS A =====

	"abrir": ["abrir", "abrí", "abril", "abrir,"],
	"abrazar": ["abrazar", "abraza", "abrazar,"],
	"abandonar": ["abandonar", "abandona", "abandonar,"],
	"absorber": ["absorber", "absorver", "absorber,"],
	"acabar": ["acabar", "acava", "acabar,"],
	"aceptar": ["aceptar", "aseptar", "acepta", "aceptar,"],
	"acercar": ["acercar", "asercar", "acercar,"],
	"acomodar": ["acomodar", "acomoda", "acomodar,"],
	"acompañar": ["acompañar", "acompanar", "acompañar,"],
	"aconsejar": ["aconsejar", "aconseja", "aconsejar,"],
	"acordar": ["acordar", "acorda", "acordar,"],
	"actuar": ["actuar", "actual", "actua", "actuar,"],
	"adaptar": ["adaptar", "adapta", "adaptar,"],
	"adivinar": ["adivinar", "adivina", "adivinar,"],
	"admirar": ["admirar", "admira", "admirar,"],
	"adoptar": ["adoptar", "adopta", "adoptar,"],
	"adorar": ["adorar", "adora", "adorar,"],
	"afectar": ["afectar", "afecta", "afectar,"],
	"afirmar": ["afirmar", "afirma", "afirmar,"],
	"agachar": ["agachar", "agacha", "agachar,"],
	"agarrar": ["agarrar", "agarar", "agarrar,"],
	"agrandar": ["agrandar", "agranda", "agrandar,"],
	"agradecer": ["agradecer", "agradeser", "agradecer,"],
	"agrupar": ["agrupar", "agrupa", "agrupar,"],
	"aguantar": ["aguantar", "aguanta", "aguantar,"],
	"ahogar": ["ahogar", "ahoga", "ahogar,"],
	"ahorrar": ["ahorrar", "aorrar", "ahorrar,"],
	"alcanzar": ["alcanzar", "alcansa", "alcanzar,"],
	"alegrar": ["alegrar", "alegra", "alegrar,"],
	"alejar": ["alejar", "aleja", "alejar,"],
	"alimentar": ["alimentar", "alimenta", "alimentar,"],
	"aliviar": ["aliviar", "alivia", "aliviar,"],
	"alquilar": ["alquilar", "alkilar", "alquilar,"],
	"amar": ["amar", "ama", "amar,"],
	"amenazar": ["amenazar", "amenasa", "amenazar,"],
	"andar": ["andar", "anda", "andar,"],
	"anhelar": ["anhelar", "anela", "anhelar,"],
	"anotar": ["anotar", "anota", "anotar,"],
	"apagar": ["apagar", "apaga", "apagar,"],
	"aparecer": ["aparecer", "aparece", "aparecer,"],
	"apartar": ["apartar", "aparta", "apartar,"],
	"aplaudir": ["aplaudir", "aplaude", "aplaudir,"],
	"aplicar": ["aplicar", "aplica", "aplicar,"],
	"apoyar": ["apoyar", "apolla", "apoyar,"],
	"aprender": ["aprender", "aprende", "aprender,"],
	"apretar": ["apretar", "aprieta", "apretar,"],
	"aprobar": ["aprobar", "aprueba", "aprobar,"],
	"aprovechar": ["aprovechar", "aprovecha", "aprovechar,"],
	"armar": ["armar", "arma", "armar,"],
	"arrancar": ["arrancar", "arranca", "arrancar,"],
	"arreglar": ["arreglar", "arregla", "arreglar,"],
	"arrojar": ["arrojar", "arroja", "arrojar,"],
	"asustar": ["asustar", "asusta", "asustar,"],
	"atacar": ["atacar", "ataca", "atacar,"],
	"atraer": ["atraer", "atrae", "atraer,"],
	"atrapar": ["atrapar", "atrapa", "atrapar,"],
	"atravesar": ["atravesar", "atravezar", "atravesar,"],
	"aumentar": ["aumentar", "aumenta", "aumentar,"],
	"ayudar": ["ayudar", "alludar", "ayudar,"],

	# ===== VERBOS E =====

	"echar": ["echar", "hechar", "echa", "echar,"],
	"editar": ["editar", "edita", "editar,"],
	"educar": ["educar", "educa", "educar,"],
	"elegir": ["elegir", "elejir", "elige", "elegir,"],
	"elevar": ["elevar", "eleva", "elevar,"],
	"eliminar": ["eliminar", "elimina", "eliminar,"],
	"embarcar": ["embarcar", "embarca", "embarcar,"],
	"embellecer": ["embellecer", "embelleze", "embellecer,"],
	"empezar": ["empezar", "empesar", "empezar,"],
	"emplear": ["emplear", "emplea", "emplear,"],
	"empujar": ["empujar", "empuja", "empujar,"],
	"encantar": ["encantar", "encanta", "encantar,"],
	"encender": ["encender", "enciende", "encender,"],
	"encerrar": ["encerrar", "encierra", "encerrar,"],
	"encontrar": ["encontrar", "encuentra", "encontrar,"],
	"engañar": ["engañar", "enganar", "engañar,"],
	"enseñar": ["enseñar", "ensenar", "enseñar,"],
	"entrar": ["entrar", "entra", "entrar,"],
	"enviar": ["enviar", "embiar", "enviar,"],
	"escapar": ["escapar", "escapa", "escapar,"],
	"escoger": ["escoger", "escojer", "escoger,"],
	"esconder": ["esconder", "esconde", "esconder,"],
	"escribir": ["escribir", "escrivir", "escribir,"],
	"escuchar": ["escuchar", "escucha", "escuchar,"],
	"esperar": ["esperar", "espera", "esperar,"],
	"estudiar": ["estudiar", "estudia", "estudiar,"],
	"evitar": ["evitar", "evita", "evitar,"],
	"evocar": ["evocar", "evoca", "evocar,"],
	"existir": ["existir", "existe", "existir,"],
	"explorar": ["explorar", "explora", "explorar,"],
	"expresar": ["expresar", "expresa", "expresar,"],

	# ===== VERBOS I =====

	"ignorar": ["ignorar", "ignora", "ignorar,"],
	"igualar": ["igualar", "iguala", "igualar,"],
	"iluminar": ["iluminar", "ilumina", "iluminar,"],
	"imaginar": ["imaginar", "imagina", "imaginar,"],
	"imitar": ["imitar", "imita", "imitar,"],
	"impedir": ["impedir", "impide", "impedir,"],
	"importar": ["importar", "importa", "importar,"],
	"imprimir": ["imprimir", "imprime", "imprimir,"],
	"incluir": ["incluir", "incluír", "incluir,"],
	"indicar": ["indicar", "indica", "indicar,"],
	"influir": ["influir", "influye", "influir,"],
	"informar": ["informar", "informa", "informar,"],
	"iniciar": ["iniciar", "inicia", "iniciar,"],
	"insistir": ["insistir", "insiste", "insistir,"],
	"inspirar": ["inspirar", "inspira", "inspirar,"],
	"instalar": ["instalar", "instala", "instalar,"],
	"intentar": ["intentar", "intenta", "intentar,"],
	"interesar": ["interesar", "interesa", "interesar,"],
	"interpretar": ["interpretar", "interpreta", "interpretar,"],
	"invitar": ["invitar", "invita", "invitar,"],
	"invocar": ["invocar", "invoca", "invocar,"],

	# ===== VERBOS O =====

	"obedecer": ["obedecer", "obedece", "obedecer,"],
	"obligar": ["obligar", "obliga", "obligar,"],
	"observar": ["observar", "observa", "observar,"],
	"obtener": ["obtener", "obtener", "obtener,"],
	"ocultar": ["ocultar", "oculta", "ocultar,"],
	"ocupar": ["ocupar", "ocupa", "ocupar,"],
	"ofender": ["ofender", "ofende", "ofender,"],
	"ofrecer": ["ofrecer", "ofrese", "ofrecer,"],
	"olvidar": ["olvidar", "olvida", "olvidar,"],
	"opinar": ["opinar", "opina", "opinar,"],
	"ordenar": ["ordenar", "ordena", "ordenar,"],
	"organizar": ["organizar", "organisa", "organizar,"],
	"orientar": ["orientar", "orienta", "orientar,"],

	# ===== VERBOS U =====

	"ubicar": ["ubicar", "ubica", "ubicar,"],
	"unificar": ["unificar", "unifica", "unificar,"],
	"unir": ["unir", "une", "unir,"],
	"usar": ["usar", "usa", "usar,"],
	"utilizar": ["utilizar", "utilisar", "utilizar,"]

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
