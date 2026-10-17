class_name InspetorEditorProperty


static func get_all_property(resource: Resource) -> Dictionary:
	var data_text : Dictionary = {}
	if not resource:
		return data_text
	
	for prop in resource.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name = prop.name
			var value = resource.get(name)
			data_text[name] = value
	
	return data_text

static func set_variable_in_text(resource: Resource, variable_name: String, text_value: String) -> bool:
	if not resource:
		return false

	# Verifica se a propriedade existe no Resource
	var original_type: int = -1
	for prop in resource.get_property_list():
		if prop.name == variable_name and (prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE):
			original_type = prop.type
			break

	if original_type == -1:
		push_error("Variável '" + variable_name + "' não foi encontrada no Resource.")
		return false

	var converted_value : Variant

	# Converte a String de entrada para o tipo de dado original da variável (int, float, Vector2, bool, etc.)
	if original_type == TYPE_STRING:
		converted_value = text_value
	elif original_type == TYPE_OBJECT:
		# Se for um Resource carregado via caminho de arquivo "res://..."
		if ResourceLoader.exists(text_value):
			converted_value = load(text_value)
		else:
			converted_value = null
	else:
		converted_value = str_to_var(text_value)
	
	# Define o novo valor no Resource
	resource.set(variable_name, converted_value)
	return true
