import subprocess
import re


whisper = r"C:\Users\viznu\OneDrive\Documents\Projects\-abc\-abc\whisper\whisper-stream.exe"
model = r"C:\Users\viznu\OneDrive\Documents\Projects\-abc\-abc\whisper\ggml-base.bin"
output = r"C:\Users\viznu\AppData\Roaming\Godot\app_userdata\-abc\stream_out.txt"

cmd = [whisper, "-m", model, "-l", "es",
	"--step", "2000", "--length", "4000",
	"--keep", "300", "-vth", "0.4", "-t", "12"]

proc = subprocess.Popen(cmd,
	stdout=subprocess.PIPE,
	stderr=subprocess.STDOUT,
	text=True,
	encoding="utf-8",
	errors="replace")

ansi_escape = re.compile(r'(\x1b\[[0-9;]*[A-Za-z]|\[2K|\r)')

with open(output, "w", encoding="utf-8") as f:
	for line in proc.stdout:
		clean = ansi_escape.sub("", line).strip()
		if clean == "":
			continue
		if any(clean.startswith(x) for x in ["whisper_", "main:", "init:", "SDL_", "ggml_", "[Start"]):
			continue
		f.write(clean + "\n")
		f.flush()
		print("Guardado:", clean)