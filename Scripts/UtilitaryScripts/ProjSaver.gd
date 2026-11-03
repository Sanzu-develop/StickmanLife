class_name ProjFormatSaver
extends ResourceFormatSaver

# 1. Define quais extensões este saver reconhece
func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
	return PackedStringArray(["proj","anim"])

# 2. Define se o saver aceita salvar este recurso específico
func _recognize(resource: Resource) -> bool:
	# Retorna true se for o tipo de recurso que você quer salvar com essa extensão
	return true # Ou coloque uma checagem tipo: return resource is MeuTipoDeProjeto

# 3. A lógica principal de salvamento
func _save(resource: Resource, path: String, flags: int) -> Error:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return FileAccess.get_open_error()
	
	# var_to_str consegue serializar estruturas complexas e Resources internos!
	var serialized_data = var_to_str(resource)
	
	file.store_string(serialized_data)
	return OK
