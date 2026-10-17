class_name DynamicUIFactory


# Função para criar o controle de UI adequado baseado no valor recebido
static func create_control(init_value: Variant) -> Control:
	var type: Variant.Type = typeof(init_value) as Variant.Type
	match type:
		TYPE_BOOL:
			var check_box = CheckBox.new()
			check_box.button_pressed = init_value
			return check_box
			
		TYPE_INT:
			var spin_box = SpinBox.new()
			spin_box.step = 1
			spin_box.min_value = -999999
			spin_box.max_value = 999999
			spin_box.value = init_value
			return spin_box
			
		TYPE_FLOAT:
			var spin_box = SpinBox.new()
			spin_box.step = 0.01
			spin_box.min_value = -999999.0
			spin_box.max_value = 999999.0
			spin_box.value = init_value
			return spin_box
			
		TYPE_STRING, TYPE_STRING_NAME:
			var line_edit = LineEdit.new()
			line_edit.text = str(init_value)
			return line_edit
			
		TYPE_COLOR:
			var color_picker = ColorPickerButton.new()
			color_picker.color = init_value
			return color_picker
			
		TYPE_VECTOR2, TYPE_VECTOR2I:
			# Dica: Você pode criar um HBoxContainer com 2 SpinBoxes para X e Y
			return _create_vector2_ui(init_value)
			
		_:
			# Fallback para types não mapeados explicitamente (mostra como texto)
			var line_edit = LineEdit.new()
			line_edit.text = str(init_value)
			line_edit.editable = false
			return line_edit

static func _create_vector2_ui(vetor) -> HBoxContainer:
	var container = HBoxContainer.new()
	var spin_x = SpinBox.new()
	var spin_y = SpinBox.new()
	
	spin_x.min_value = -999999
	spin_x.max_value = 999999
	spin_y.min_value = -999999
	spin_y.max_value = 999999
	
	spin_x.value = vetor.x
	spin_y.value = vetor.y
	
	container.add_child(spin_x)
	container.add_child(spin_y)
	
	spin_x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spin_y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return container

# Conecta o controle ao callback desejado, independente de qual seja o nó
static func connect_value_changed(control: Control, callback: Callable) -> void:
	if not control or not callback.is_valid():
		return

	if control is CheckBox:
		# CheckBox emite toggled(toggled_on: bool)
		control.toggled.connect(func(val: bool): callback.call(val))

	elif control is SpinBox:
		# SpinBox emite value_changed(value: float)
		control.value_changed.connect(func(val: float): callback.call(val))

	elif control is LineEdit:
		# LineEdit emite text_changed(new_text: String)
		control.text_changed.connect(func(val: String): callback.call(val))

	elif control is ColorPickerButton:
		# ColorPickerButton emite color_changed(color: Color)
		control.color_changed.connect(func(val: Color): callback.call(val))

	elif control is HBoxContainer:
		# Caso especial: Vector2 (Container com 2 SpinBoxes)
		var spin_x = control.get_child(0) as SpinBox
		var spin_y = control.get_child(1) as SpinBox
		
		if spin_x and spin_y:
			var emit_vec = func(_ignored_val = null):
				callback.call(Vector2(spin_x.value, spin_y.value))
			
			spin_x.value_changed.connect(emit_vec)
			spin_y.value_changed.connect(emit_vec)
