class_name FFmpeg
extends Control


signal ffmpeg_error(task: String,error: String)

# Caminho para o executável do FFmpeg
var ffmpeg_path: String = ""

var animation_frames: Array[ImageTexture] = []


func _ready() -> void:
	# Descobre o caminho correto dependendo se estamos rodando no editor ou exportado
	if OS.has_feature("editor"):
		# Caminho absoluto na sua máquina para teste rápido, ou relativo ao res://
		ffmpeg_path = ProjectSettings.globalize_path("res://addons/ffmpeg/ffmpeg.exe")
	else:
		ffmpeg_path = OS.get_executable_path().get_base_dir().path_join("ffmpeg.exe")
	
	test_ffmpeg()

func test_ffmpeg() -> void:
	var output = []
	# Executa o ffmpeg pedindo apenas a versão
	var exit_code = OS.execute(ffmpeg_path, ["-version"], output, true)
	
	if exit_code == 0:
		Log.register_log("Sucesso! FFmpeg encontrado e rodando.")
		Log.register_log(["Versão: ", output[0].split("\n")[0]]) # Mostra a primeira linha da versão
	else:
		ffmpeg_error.emit("testing ffmpeg - ",str(exit_code))
		Log.register_log(["Erro ao executar o FFmpeg. Código de saída: ", exit_code])

func import_mp4_for_frame(path_mp4: String, path_destine: String, fps: int = 30) -> void:
	# Garante que a path de destino existe
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(path_destine))
	
	var abs_mp4 = ProjectSettings.globalize_path(path_mp4)
	var abs_destine = ProjectSettings.globalize_path(path_destine)
	
	# Padrão de nome dos quadros gerados: frame_0001.png, frame_0002.png...
	var standart_output = abs_destine.path_join("frame_%04d.png")
	
	# Argumentos do FFmpeg:
	# -i : arquivo de entrada
	# -vf fps=30 : força a extração a 30 quadros por segundo
	var arguments = [
		"-i", abs_mp4,
		"-vf", "fps=%s" % fps,
		standart_output
	]
	
	Log.register_log("Extraindo frames do vídeo... Aguarde.")
	var output = []
	var exit_code = OS.execute(ffmpeg_path, arguments, output, true)
	
	if exit_code == 0:
		Log.register_log(["Vídeo importado com sucesso para a path: ", path_destine])
		load_frame_for_memory(path_destine)
	else:
		ffmpeg_error.emit(["import mp4 - ",str(exit_code)])
		Log.register_log("Erro na conversão do vídeo.")

func load_frame_for_memory(path: String) -> void:
	animation_frames.clear()
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		# Lista todos os files PNG gerados
		var list_files = []
		while file != "":
			if not dir.current_is_dir() and file.ends_with(".png"):
				list_files.append(file)
			file = dir.get_next()
		
		# Ordena em ordem alfabética (frame_0001.png, frame_0002.png...)
		list_files.sort()
		
		for f in list_files:
			var path_full = path.path_join(f)
			var img = Image.load_from_file(path_full)
			var texture = ImageTexture.create_from_image(img)
			animation_frames.append(texture)
			
		Log.register_log(["Carregados ", animation_frames.size(), " quadros para a memória!"])

func export_mp4_frames(path_origem: String, file_mp4_output: String, fps: int = 30) -> void:
	var abs_origem = ProjectSettings.globalize_path(path_origem).path_join("frame_%04d.png")
	var abs_saida = ProjectSettings.globalize_path(file_mp4_output)
	
	var arguments = [
		"-framerate", str(fps),            # 30 quadros por segundo
		"-i", abs_origem,              # Entrada com os frames numerados
		"-c:v", "libx264",             # Codec de vídeo H.264 (compatível com tudo)
		"-pix_fmt", "yuv420p",         # Formato de cor padrão exigido por players de MP4
		"-y",                          # Sobrescreve o arquivo de saída se já existir
		abs_saida
	]
	
	Log.register_log("Gerando arquivo MP4...")
	var output = []
	var exit_code = OS.execute(ffmpeg_path, arguments, output, true)
	
	if exit_code == 0:
		Log.register_log(["Vídeo MP4 exportado com sucesso em: ", file_mp4_output])
	else:
		ffmpeg_error.emit("export mp4 - ",str(exit_code))
		Log.register_log("Erro ao exportar o vídeo.")

func get_mp4_frames() -> Array[ImageTexture]:
	return animation_frames
