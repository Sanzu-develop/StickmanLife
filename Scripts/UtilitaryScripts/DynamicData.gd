class_name DynamicData

static func get_control_value(node: Control, standart_value: Variant = null) -> Variant:
	match true:
		_ when "value" in node:
			return node.value
		_ when "text" in node:
			return node.text
		_ when "button_pressed" in node:
			return node.button_pressed
		_ when "selected" in node:
			return node.selected
		_ when "color" in node:
			return node.color
		_:
			return standart_value

static func set_control_value(node: Control, new_value: Variant) -> bool:
	match true:
		_ when "value" in node:
			if new_value is int or new_value is float:
				node.value = new_value
			else:
				return false
				
		_ when "text" in node:
			node.text = str(new_value)
			
		_ when "button_pressed" in node:
			if new_value is bool:
				node.button_pressed = new_value
			else:
				return false
				
		_ when "selected" in node:
			if new_value is int:
				node.selected = new_value
			else:
				return false
				
		_ when "color" in node:
			if new_value is Color:
				node.color = new_value
			else:
				return false
		_:
			return false
	
	return true
