class_name ProjFormatLoader
extends ResourceFormatLoader

# 1. Define quais extensões este loader reconhece
func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["proj"])

# 2. Define o tipo de recurso que ele retorna (geralmente "Resource" ou o nome da sua classe customizada)
func _get_resource_type(path: String) -> String:
	if path.get_extension().to_lower() == "proj":
		return "Resource" # Ou substitua pelo nome da sua classe se herdar de Resource (ex: "Project")
	return ""

# 3. Informa ao Godot se este loader lida com arquivos customizados
func _handles_type(typename: StringName) -> bool:
	return typename == &"Resource" # Ajuste se usar um tipo específico

# 4. A lógica principal de carregamento
func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return FileAccess.get_open_error()
	
	var content = file.get_as_text()
	
	# str_to_var reconstrói perfeitamente o objeto e seus sub-resources
	var restored_data = str_to_var(content)
	
	if restored_data == null:
		printerr("Erro ao converter string para variável no arquivo .proj")
		return FAILED
		
	return restored_data
